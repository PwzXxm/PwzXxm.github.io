# CLDictP: A Command-Line Dictionary Tool


A command line dictionary written in Perl using Merriam-Webster APIs.

This is my first project using Perl. I feel it is tedious to type formatted definitions to [Quizlet](https://quizlet.com/)(A website which can make flashcards for you) and I'm too lazy to open browser and online dictionary pages. Why not combining these two?

It uses following APIs:

- Merriam-Webster Learner

- Merriam-Webster Collegiate

For each entry, it contains:

- Pronunciation: IPA(International Phonetic Alphabet)

- Part of Speech

- Grammar

- Definition

- Common Usage

- Examples

All searched words are saved in a set and saved to `searched.txt`.

It also save searched words and definitions into the file `quizlet.txt` so that they can be imported into [Quizlet](https://quizlet.com/) which makes flashcards. The format is:

- between term and definition: `$`

- between cards: `---`

## Usage

1. Get API Keys: [DictionaryAPI](https://www.dictionaryapi.com/).

2. Add API Keys to `api_template.json` and change the file name to `api.json`.

3. Install dependencies with

    ``` bash
    $ cpan Term::ANSIColor Term::ReadKey LWP::UserAgent LWP::Protocol::https Readonly XML::LibXML JSON::XS Data::Dumper Set::Light
    ```

4. Run the script with

    ``` bash
    $ perl dict.pl
    ```

5. To exit, use Ctrl+D.

## Demo

![demo_gif](CLDictP_demo.gif)

## Source Files

The source files are hosted on [Github](https://github.com/PwzXxm/CLDictP).
