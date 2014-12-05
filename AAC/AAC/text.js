var sentences, wordsCount, wordsPerSentence, averageWordLength;
function analyzeText(text) {
    var textString = text;
    if (textString.replace(/\s*/g,'').length == 0)
        return;
    textString = textString.replace(/(\.\.\.|!|\?)/g, ".").replace(/\s*$/g, "");
    try {
        sentences = textString.match(/\./g).length + (textString.charAt(textString.length-1) === '.'?0:1);
    }
    catch (er) {
        sentences = 1;
    }
    try {
        sentences -= textString.match(/\.\w\w?\./g).length;
    }
    catch (er) {}
    try {
        sentences -= textString.match(/\s\w\w?\./g).length;
    }
    catch (er) {}
    textString = textString.replace(/(\.\s*\w)/ig, function($0) { return $0.toLowerCase(); });
    var shorts;
    try {
        shorts = textString.match(/(can|don|it|wouldn|aren|he|she|i|you|we|won|didn|ain|isn|doesn)['â€˜â€™](t|s|m|re|ll)/ig).length;
                                                                                                   } catch (er) {
                                                                                                   shorts = 0;
                                                                                                   }
                                                                                                   textString = textString.replace(/[,\.\\\/\(\)\:\"\';\[\]â€¦â€˜â€™â€žâ€œâ€Â«Â»â€”â€“-]/g, " ");
                                                                                                                                     textString = textString.replace(/\s\s+/g, " ").replace(/^\s+|\s+$/g, "");
                                                                                                                                     if (sentences === 0)
                                                                                                                                     sentences = 1;
                                                                                                                                     var wordsArray = textString.split(' ');
                                                                                                                                     wordsCount = wordsArray.length - shorts;
                                                                                                                                     wordsPerSentence = Math.round(wordsCount / sentences);
                                                                                                                                     var totalWordsLength = 0;
                                                                                                                                     for (var key in wordsArray)
                                                                                                                                     totalWordsLength += wordsArray[key].length;
                                                                                                                                     averageWordLength = Math.round(totalWordsLength / wordsCount);
                                                                                                                                     }
                                                                                                                                     
                                                                                                                                     function getSentences() {
                                                                                                                                     return sentences;
                                                                                                                                     }
                                                                                                                                     
                                                                                                                                     function getWordsCount() {
                                                                                                                                     return wordsCount;
                                                                                                                                     }
                                                                                                                                     
                                                                                                                                     function getWordsPerSentence() {
                                                                                                                                     return wordsPerSentence;
                                                                                                                                     }
                                                                                                                                     
                                                                                                                                     function getAverageWordLength() {
                                                                                                                                     return averageWordLength;
                                                                                                                                     }