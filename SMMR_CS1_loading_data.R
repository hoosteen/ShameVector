# Import positive lexicons
pos <- scan(file.path
  ("C:/Users/Justin/Documents/R",
   'positive-words.txt'), what = 'character',
  comment.char = ';')

# import financial positive lexicon
pos_finance <- scan(file.path(
  "C:/Users/Justin/Documents/R",
  'LoughranMcDonald_pos.csv'),
  what = 'character',comment.char = ';')

# combine both files into one
pos_all <- c(pos, pos_finance)

# load general negative words lexicon
neg <- scan(file.path("C:/Users/Justin/Documents/R",
            "neg_words.txt"),
            what = 'character', comment.char = ';')

# load financial negative words lexicon
neg_finance <- scan(file.path(
                    "C:/Users/Justin/Documents/R",
                    "LoughranMcDonald_pos.csv"),
                    what = 'character', comment.char = ';')

# combine negative words into single file
neg_all <- c(neg, neg_finance)

# Import Beige Book 
BB <- read.csv("C:/Users/Justin/Documents/R/beigebook_summary.csv")

