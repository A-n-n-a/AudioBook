//
//  LibraryFeature.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

import ComposableArchitecture
import Foundation

public struct LibraryFeature: Reducer {
    public struct State: Equatable {
        var books: [Book] = []
        var currentBook: Book?
        var currentChapter: Chapter?
        
        var isSwitchToNextAvailable: Bool {
            if isLastChapterInBook && isLastBookInLibrary {
                return false
            }
            return true
        }
        
        var isSwitchToPreviousAvailable: Bool {
            if isFirstChapterInBook && isFirstBookInLibrary {
                return false
            }
            return true
        }
        
        var isFirstChapterInBook: Bool {
            guard let chapterIndex else {
                return true
            }
            return chapterIndex == 0
        }
        
        var isLastChapterInBook: Bool {
            guard let chapterIndex else {
                return true
            }
            return chapterIndex == (currentBook?.chapters.count ?? 0) - 1
        }
        
        var isFirstBookInLibrary: Bool {
            guard let bookIndex else {
                return true
            }
            return bookIndex == 0
        }
        
        var isLastBookInLibrary: Bool {
            guard let bookIndex else {
                return true
            }
            return bookIndex == books.count - 1
        }
        
        var chapterIndex: Int? {
            guard
                let currentBook,
                let currentChapter,
                let currentIndex = currentBook.chapters.firstIndex(of: currentChapter) else {
                return nil
            }
            return currentIndex
        }
        
        var bookIndex: Int? {
            guard
                let currentBook,
                let currentIndex = books.firstIndex(of: currentBook) else {
                return nil
            }
            return currentIndex
        }
        
        var nextBook: Book? {
            if let bookIndex {
                return books[safe: bookIndex + 1]
            }
            return books.first
        }
        
        var previousBook: Book? {
            if let bookIndex {
                return books[safe: bookIndex - 1]
            }
            return nil
        }
        
        var nextChapter: Chapter? {
            if isLastChapterInBook {
                return nextBook?.chapters.first
            } else if let chapterIndex {
                print("[Chapter index]", chapterIndex)
                return currentBook?.chapters[safe: chapterIndex + 1]
            }
            return books.first?.chapters.first
        }
        
        var previousChapter: Chapter? {
            if isFirstChapterInBook {
                return previousBook?.chapters.first
            } else if let chapterIndex {
                return currentBook?.chapters[safe: chapterIndex - 1]
            }
            return nil
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case onAppear
        case selectBook(UUID)
        case selectChapter(UUID)
        case selectNext
        case selectPrevious
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.books = Self.sampleBooks
            if state.currentBook == nil {
                state.currentBook = state.books.first
                print("[Current Book] 123", state.currentBook?.title ?? "nil")
                state.currentChapter = state.currentBook?.chapters.first
            }
            return .none

        case let .selectBook(bookId):
            state.currentBook = state.books.first(where: { $0.id == bookId })
            print("[Current Book] 129", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
            return .none
            
        case let .selectChapter(chapterId):
            state.currentChapter = state.currentBook?.chapters.first(where: { $0.id == chapterId })
            return .none
        case .selectNext:
            selectNextChapter(state: &state)
            return .none
        case .selectPrevious:
            selectPreviousChapter(state: &state)
            return .none
        }
    }
    
    private func selectNextChapter(state: inout State) {
        if state.isLastChapterInBook {
            state.currentBook = state.nextBook
            print("[Current Book] 148", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
        } else {
            state.currentChapter = state.nextChapter
        }
    }
    
    private func selectPreviousChapter(state: inout State) {
        if state.isFirstChapterInBook {
            state.currentBook = state.previousBook
            print("[Current Book] 158", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
        } else {
            state.currentChapter = state.previousChapter
        }
    }
}

extension LibraryFeature {
    static let sampleBooks: [Book] = [
        Book(
            id: UUID(),
            imageName: "autumn_leaves",
            title: "Autumn Leaves",
            author: "Anne Wales Abbot",
            chapters: [
                Chapter(
                    id: UUID(),
                    title: "Christmas Revived",
                    fileName: "autumnleaves_01_abbot_64kb",
                    fileExtension: "mp3",
                    description: """
                    <h2>📖 Chapter 1 – “Christmas Revived”</h2>
                    <p>
                      In this opening tale, we follow <strong>Nathan Stoddard</strong>, a young saddler, as he walks through the quiet streets of a New England town on Christmas morning.
                      His routine is interrupted when he notices an unusual old man, dressed in black with flowing white hair, knocking on the door of the local church.
                    </p>

                    <p>
                      To Nathan's astonishment, the door opens, and the man enters. Curious, Nathan peeks inside and discovers a lively gathering of young people in old-fashioned attire,
                      joyfully decorating the church for a celebration. This unexpected scene fills Nathan with a sense of wonder and reflection, capturing the nostalgic and communal spirit of Christmas.
                      (<a href="https://www.gutenberg.org/ebooks/17189" target="_blank">gutenberg.org</a>)
                    </p>

                    <p>
                      The story blends elements of mystery and sentimentality, evoking a longing for the warmth and togetherness of traditional holiday celebrations.
                      It sets the tone for the rest of the collection, which explores themes of nostalgia, community, and the simple joys of life.
                    </p>

                    <p>
                      This chapter serves as a gentle reminder of the enduring magic of Christmas and the importance of community and tradition.
                    </p>
                """),
                Chapter(
                    id: UUID(),
                    title: "In the Churchyard at Cambridge: A Legend of Lady Lee",
                    fileName: "autumnleaves_02_abbot_64kb",
                    fileExtension: "mp3",
                    description: """
                    <h2>📖 Chapter 2 – “In the Churchyard at Cambridge: A Legend of Lady Lee”</h2>

                    <p>
                      This brief yet evocative piece, titled <em>“In the Churchyard at Cambridge: A Legend of Lady Lee”</em>, transports readers to a serene churchyard in Cambridge. 
                      The narrative unfolds as a legend, recounting the tale of Lady Lee, a figure enveloped in mystery and reverence. 
                      Through poetic prose, the story delves into themes of love, loss, and the enduring nature of memory.
                    </p>

                    <p>
                      The churchyard setting serves as a poignant backdrop, symbolizing the intersection of life and death, past and present. 
                      Lady Lee's story, though succinctly told, resonates with emotional depth, inviting readers to reflect on the legacies we leave behind and the stories that outlive us.
                    </p>

                    <p>
                      This chapter exemplifies the collection's overarching themes of nostalgia and introspection, offering a contemplative pause that encourages readers to ponder the transient yet impactful nature of human existence.
                    </p>

                    <p>
                      For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/17189" target="_blank">Project Gutenberg</a>.
                    </p>
                """),
                Chapter(
                    id: UUID(),
                    title: "The Little South-Wind",
                    fileName: "autumnleaves_03_abbot_64kb",
                    fileExtension: "mp3",
                    description: """
                    <h2>📖 Chapter 3 – “The Little South-Wind”</h2>

                    <p>
                      In this charming poetic piece, <em>“The Little South-Wind”</em> personifies a gentle breeze as a playful and benevolent spirit. 
                      The narrative follows the South-Wind as it meanders through the natural world, bringing warmth and vitality to the landscapes it touches. 
                      Its presence awakens dormant flowers, stirs the waters, and infuses the environment with a renewed sense of life and joy.
                    </p>

                    <p>
                      The poem employs vivid imagery and lyrical language to capture the essence of the South-Wind's journey. 
                      Through its interactions with nature, the South-Wind symbolizes the arrival of spring and the rejuvenation that comes with it. 
                      The piece reflects on themes of renewal, the interconnectedness of nature, and the subtle yet profound impact of seemingly small forces.
                    </p>

                    <p>
                      This chapter continues the collection's exploration of nature's beauty and the emotional resonance found in its cycles. 
                      It invites readers to appreciate the delicate influences that shape our world and to find inspiration in the gentle transformations that herald new beginnings.
                    </p>

                    <p>
                      For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/17189" target="_blank">Project Gutenberg</a>.
                    </p>
                """),
            ]
        ),
        Book(
            id: UUID(),
            imageName: "under_the_gun",
            title: "Under the Gun",
            author: "Annie Wittenmyer",
            chapters: [
                Chapter(
                    id: UUID(),
                    title: "A Boy Sent by Express C.O.D.",
                    fileName: "undertheguns_01_wittenmyer_64kb",
                    fileExtension: "mp3",
                    description: """
                    <h2>📖 Section 1 – “A Boy Sent by Express C.O.D.”</h2>

                    <p>
                      In the opening chapter, <em>“A Boy Sent by Express C.O.D.”</em>, Annie Wittenmyer recounts a poignant and extraordinary incident from her Civil War experiences. 
                      A young boy, orphaned and alone, is sent to her care via express delivery, labeled "Collect on Delivery." 
                      This unusual and heart-wrenching event underscores the desperate measures taken during the war and highlights the profound impact of conflict on innocent lives.
                    </p>

                    <p>
                      Wittenmyer’s narrative sheds light on the broader humanitarian crises faced during the Civil War, particularly the plight of orphans and the responsibilities shouldered by civilians. 
                      Her compassionate response to the boy's arrival exemplifies the empathy and resilience of those who worked tirelessly to provide relief amidst the chaos of war.
                    </p>

                    <p>
                      This chapter sets the tone for the memoir, offering readers a glimpse into the personal challenges and moral complexities encountered by those on the home front. 
                      It emphasizes the themes of compassion, duty, and the far-reaching consequences of war on society's most vulnerable members.
                    </p>

                    <p>
                      For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/73190" target="_blank">Project Gutenberg</a>.
                    </p>
                """),
                Chapter(
                    id: UUID(),
                    title: "A Perilous Ride",
                    fileName: "undertheguns_02_wittenmyer_64kb",
                    fileExtension: "mp3",
                    description: """
                <h2>📖 Section 2 – “A Perilous Ride”</h2>

                <p>
                  In this gripping chapter, <em>“A Perilous Ride”</em>, Annie Wittenmyer recounts a harrowing journey undertaken during the Civil War. 
                  Tasked with delivering critical supplies and messages to Union forces, she embarks on a ride through treacherous terrain, facing the constant threat of enemy encounters and natural obstacles.
                </p>

                <p>
                  Wittenmyer's narrative vividly captures the dangers faced by civilians who took on support roles during the war. 
                  Her determination and courage are evident as she navigates through hostile environments, driven by a commitment to aid the soldiers and contribute to the Union's efforts.
                </p>

                <p>
                  This chapter highlights the often-overlooked contributions of women in wartime logistics and the personal risks they endured. 
                  Wittenmyer's experience serves as a testament to the vital roles played by non-combatants in supporting military operations and the resilience required to undertake such perilous tasks.
                </p>

                <p>
                  For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/73190" target="_blank">Project Gutenberg</a>.
                </p>
                """),
                Chapter(
                    id: UUID(),
                    title: "A Woman's Reminiscences of the Civil War",
                    fileName: "undertheguns_03_wittenmyer_64kb",
                    fileExtension: "mp3",
                    description: """
                <h2>📖 Section 3 – “A Woman's Reminiscences of the Civil War”</h2>

                <p>
                  In this section, Annie Wittenmyer provides a poignant account of her experiences as a nurse and aid worker during the American Civil War. 
                  She highlights the critical roles women played in supporting soldiers and tending to the wounded, offering a unique perspective on the war from a woman's viewpoint.
                </p>

                <p>
                  Wittenmyer describes how she became involved in hospital work when camps were established near her home in Iowa. 
                  She details her early experiences ministering to soldiers and witnessing the impact of the war firsthand. 
                  Her narrative emphasizes the bravery and decency of soldiers, recounting her interactions with military leaders and the heartfelt incidents she encountered.
                </p>

                <p>
                  This section sets the tone for Wittenmyer's memoir, focusing on real-life incidents and heartfelt stories rather than military history. 
                  It underscores her deep compassion for the suffering endured and her respect for those who served.
                </p>

                <p>
                  For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/73190" target="_blank">Project Gutenberg</a>.
                </p>
                """),
                Chapter(
                    id: UUID(),
                    title: "A Woman Wounded in Battle",
                    fileName: "undertheguns_04_wittenmyer_64kb",
                    fileExtension: "mp3",
                    description: """
                <h2>📖 Section 4 – “A Woman Wounded in Battle”</h2>

                <p>
                  In this compelling chapter, <em>“A Woman Wounded in Battle”</em>, Annie Wittenmyer recounts the extraordinary story of a woman who, disguised as a male soldier, fought alongside Union troops during the Civil War. 
                  The narrative unfolds as Wittenmyer encounters this wounded soldier, only to discover the individual's true identity as a woman. 
                  This revelation highlights the lengths to which women went to participate directly in the war effort, challenging the gender norms of the time.
                </p>

                <p>
                  Wittenmyer's account sheds light on the courage and determination of women who defied societal expectations to serve their country. 
                  The chapter delves into the complexities of identity, sacrifice, and the often-overlooked roles women played on the front lines. 
                  Through this poignant story, Wittenmyer emphasizes the universal impact of war and the shared humanity of all who endured its trials.
                </p>

                <p>
                  This section contributes to the memoir's overarching themes of resilience, compassion, and the diverse experiences of those affected by the Civil War. 
                  It invites readers to reflect on the multifaceted nature of bravery and the untold stories of women who risked everything for their beliefs.
                </p>

                <p>
                  For those interested in exploring the full text, it is available through <a href="https://www.gutenberg.org/ebooks/73190" target="_blank">Project Gutenberg</a>.
                </p>
                """)
            ]
        )
    ]
}
