Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXGOU15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXGOU15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXGOU1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:27:31 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:35007 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXGOU12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:27:28 -0400
Message-ID: <469A82D6.2080004@gmail.com>
Date: Sun, 15 Jul 2007 22:25:58 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Li Yang <leo@zh-kernel.org>, Rob Landley <rob@landley.net>,
       Gerrit Huizenga <gh@us.ibm.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Chinese Language Maintainer
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>	 <200707121205.20959.rob@landley.net>	 <1184330583.23373.65.camel@Gundam>	 <200707131352.12952.rob@landley.net> <a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com> <469A6370.4020404@zytor.com>
In-Reply-To: <469A6370.4020404@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2007 08:12 PM, H. Peter Anvin wrote:

> Li Yang wrote:

>> I think you worried too much about this problem. :) Let me explain the
>> situation here in China more clearly. Actually, English is mandatory in
>> most schools and universities. Only very few people learn other
>> language as a second language. Therefore software developers who are
>> almost educated should have the basic English skill. However, that
>> doesn't mean that they can read English or communicate with native
>> English speaker very easily. Consider your second language learn in
>> school for analogy
> 
> Actually, I disagree.  English *is* the second language learned in school
> for most European developers (except, obviously, the ones from the
> British isles), and we don't have that problem.

There is somewhat of a difference though: English and both our native 
languages are very much related. English, Dutch (my native language) and 
Swedish (yours) are all Germanic languages -- English and Dutch both West 
Germanic and Swedish only slightly farther removed as North Germanic. Word 
for word translations not _too_ infrequently actually make okay or at least 
understandable Dutch...

Other than Germanic, the Slavic (Polish, Czech, Russian, ...) and Latin 
(Italian, Spanish, French, ...) language families are two other direct 
Indo-European descendants that are fairly well represented in the kernel 
community but I believe it's a largely unsurprising observation that members 
of both these families have a somewhat harder time adopting English. And 
Chinese is not even Indo-European...

However -- in Europe I notice culture might be even more important than 
school _or_ language family is and as such I believe the above argument 
isn't all that important anyway. English is the second language we learn in 
school here in the Netherlands but it's much more popular than say German, a 
language even closer to Dutch, due to us having heard English basically from 
the time we're old enough to hear music and watch TV. Most _Dutch_ bands 
sing in English and the ones that don't are for a part targetting the 
elderly and/or mentally handicapped...

German is close enough to Dutch (and English itself) to rule out most 
differences related to native language, but in Germany a significantly 
smaller percentage of people speaks English well enough to be comfortable 
with it than in the Netherlands simply due to them producing more of their 
own culture. It's a larger language zone to market to and they dub the 
remaining English-language content on TV. Over here in the Netherlands we 
sub-title.

France is another good example. While a bit farther removed from English 
family-wise, English has had lots of influences from French as well and in 
any case, learning English shouldn't be harder for a Frenchman than learning 
French is for a Dutchman (we are, or were when I was there, taught French in 
school as well) which is to say not very hard. Yet, mastery of English is 
extremely poor in France. Not as a coincedence, most _all_ of the French 
culture is in the French language including dubbed originally English songs 
for example.

Both the German and, slower, French examples get less true with every new 
generation, but both still hold...

Popular culture in the sense of music, tv and these days very much games is 
something you start to experience at a very young age, years younger than 
the Chinese will be taught English in school and age is extremely important 
in mastering a language -- the human brain is by far best at it at the time 
you start mastering your native language (in fact, this is what defines 
"native") and every single year after that makes it harder.

That is -- let's just solve our Chinese translation problem by overthrowing 
the Chinese government and forcing the sub-titled Harry Potter film-series 
down the throat of the population... |-/

Seriously, I only wanted to say that both language family and (import of) 
culture are very important and as such, concentrating on schooling alone 
might not be all that sensible. I did not want to say that I feel that all 
these translations make a great deal of sense. Some of us have an easier 
time learning English than others do, the Chinese probably don't have an 
easy time at all, but a single common language is still the thing to aim 
for. The subset and semblance of English spoken on this list seems like 
something that should serve well as that common language, especially given 
the _help_ English language education gives in it. Also, I hear China is in 
fact fairly rapidly opening up to Western (American) popular culture which 
might be an argument if you have a generation or two to spare...

Apologies for ranting...

Cheers,
Rene.

