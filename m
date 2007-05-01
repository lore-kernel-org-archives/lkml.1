Return-Path: <linux-kernel-owner+w=401wt.eu-S1031619AbXEAJXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031619AbXEAJXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031625AbXEAJXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:23:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:40352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031619AbXEAJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:23:07 -0400
Cc: mkrufky@linuxtv.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org, xyzzy@speakeasy.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 01 May 2007 11:23:05 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <4636879D.7010607@gmail.com>
Message-ID: <20070501092305.117520@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>
	<alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
	<20070429205925.129920@gmx.net>
	<alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
	<20070429230037.95120@gmx.net>	<1177894713.3046.5.camel@p
	<alpine.LFD.0.98.0704300854090.9964@woody.linux-foundation.org>
	<Pine.LNX.4.58.0704301458460.315@shell2.speakeasy.net>
 <463674A9.9040100@gmail.com> <20070430234000.181660@gmx.net>
 <4636879D.7010607@gmail.com>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21	and
	pseudo-authorities
To: Manu Abraham <abraham.manu@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+fxEhy7PGfnIS2cyOrr3sFu1mRhh3bsr83nVrOBT
 EaleibaCgHa4mMS44UjbYgKLJU0rzfmood3g== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: nW9SB4ZZfW47Qj7UCGVoDqFudmllckUO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Tue, 01 May 2007 04:19:41 +0400
Von: Manu Abraham <abraham.manu@gmail.com>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: xyzzy@speakeasy.org, linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, mkrufky@linuxtv.org
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21	and	pseudo-authorities

> Uwe Bugla wrote:
> 
> > 1. You utmost personally are responsible for 4 ununsable kernels, as far
> as bt8xx cards are concerned: 2.6.13, 2.6.14, 2.6.15, 2.6.16!
> > 2. You did not even want to imply to resolve that issue by incarnating
> that "community and synergy principle" that linux community needs to exist
> at all, but you just perverted it by flaming capable people - 
> 
> You mean like this:
> 

Yes I mean like this. But I do not only talk about me. I talk about many many others.
Above that you flamed Edgar Toernig with the invented alibi for not signing his contributions (yes I say invented alibi and I mean it exactly that way - in so far the word "gatekeeper" is no invention in this context at all, it's just a very cynical expression that shows a lot of frustration).

To get it back to the comprehensive layer:

1. 4 unusable kernels are not just another cavalier's delict, but just a very harsh and deep cut in kernel development history (read: the time space for that breakdown is close to 9 or 10 months). This could have been some three months or less if you weren't the personality that you obviously are representing.
2. Although I tried to tell you a thousand times that I prefer to optimize the existing (read: bttv dependent - even if it may sound senseless to you) concept you continued to pursue a dead born child called cx878.
This hopeful project which I would have highly admired if it ever were finished did not only die out of the personal time schedule of a very capable kaffeine developer called Christoph Pfister (who did the main work for it - not you), but it simply died as a consequence of your obviously missing knowledge.
Some i2c bus bindings were missing - in so far the mounting of a 2000 meters high mountain was cancelled 50 meters before the top.

So what do I mean by optimizing the existing concept?
Very simple: Deselectable DST module, deselectable DST_CA module, deselectable dvb-pll module - not more - not less.

Now if this very humble concept works, if all this horrible dvb_core_attach stuff and other problems are resolved let's talk about getting rid of all the not necessary bttv dependency nonsense, but never vice versa and never before that.

Read: long way, small steps, but no breakdowns.

Did I pronounce clear now, Mister Abraham? It can't be that hard to understand this, can it?

Uwe
> 
> -------- Original Message --------
> Subject: kernel patch practice in 2.6.13-mm2
> Date: Tue, 13 Sep 2005 16:46:35 +0200 (MEST)
> From: Uwe Bugla <uwe.bugla@gmx.de>
> To: manu@linuxtv.org
> CC: js@linuxtv.org
> 
> Hi,
> if you continue to send or sign mm-patches for Kernel 2.6.13 as a
> consequence of a design change I would appreciate you to stop rubbing out
> my
> name.
> You did that in a file called /Documentation/dvb/bt8xx.txt.
> My objective is understandable good documentation, even if it may sound
> trivial for some developpers minds. I always have in mind that there are
> also lots of beginners reading those documents.
> As I respect your work I never in my life would even dare to rub out other
> coauthors names.
> That´s why I appreciate you to respect my name and stop rubbing it out.
> 
> Thanks
> Uwe Bugla
> 
> P. S.: If you f. ex. publish a book I ain´t gonna burn it as a matter of
> disrespect. So have a little respect vice versa!
> 
> -- 
> Lust, ein paar Euro nebenbei zu verdienen? Ohne Kosten, ohne Risiko!
> Satte Provisionen für GMX Partner: http://www.gmx.net/de/go/partner
> 
> 
> ------- Original Message --------
> Subject: "synchronization problems"
> Date: Thu, 15 Sep 2005 10:44:38 +0200 (MEST)
> From: Uwe Bugla <uwe.bugla@gmx.de>
> To: js@linuxtv.org
> CC: manu@linuxtv.org
> 
> Hallo Mr. Stezenbach,
> 
> "You breached the protocol by not sending the patches to the maintainer
> or linux-dvb list. The result of this was that we had conflicting
> changes in CVS. I spent about 10 minutes thinking how I could
> merge the two, and then gave up (I had 53 other patches to prepare
> and I had little time left to do the job). So I didn't just remove
> your name, but all changes which you sent to akpm along with it.
> bt8xx.txt in the kernel is now in sync with the version in linuxtv.org
> CVS."
> 
> I didn't breach any protocol, nor did I break any unwritten rule or law. I
> simply took the advice from Gerd Knorr that linuxtv maintainers were just
> moving to another place to the point of time when I sent in my first
> dvb-bt8xx-patch. So consequently I took the direct way to send it to akpm.
> Just to be sure it is really being applied without waiting 3, 4 weeks or
> however long. So if you continue to at least discussing with my person,
> please immediately stop doing that in such a bureaucratic manner. If
> synchronization of CVS and kernel.org only works unidirectional, and not
> bidirectional, then neither I, nor akpm, nor Manu or anybody else has a
> real
> problem, but you personally have one without any doubts.
> And if you lack time, simply delegate your job to another person. But
> simply
> stop rubbing out other peoples coauthorship and pay respect to their
> contributions. And the biggest joke about your personal misbehaviour is
> the
> fact that you personally cosigned at least one of my patch attempts,
> without
> dropping me a single note asking me to not bypass the linuxtv CVS
> maintainers. So good morning Mr. Stezenbach, I appreciate you to wake up a
> little bit earlier in the future!
> 
> "Additionally you deleted information from bt8xx.txt which I think were
> useful help for debugging problems, and which were written there on
> purpose
> by the developer. So if you talk about respect, you could show some
> yourself
> by not bypassing the original authors and maintainers when sending
> patches."
> 
> In fact I did, and I can tell you the simple reasons why.
> There are in fact two things that I simply cannot and will not tolerate:
> a. orthographic junk (examples: "bythe" or, even worse: "autodected" and
> "Recognise") It was ME who corrected that in the past, and it was YOU
> personally who reversed that, if not to say: fucked it up in the current
> 2.6.14-rc1. So as a consequence it is YOUR task to do your homework and
> apologize for that, but not MINE!
> b. attempts of documentation that do NOT correspond to their appropriate
> kernel design
> What do I mean with b.?
> 1. In Kernels 2.6.12 AND 2.6.13 the simple command "modprobe dvb-bt8xx"
> caused ALL OTHER modules to load automatically:
> cx24110, dst, dst-ci and dst-ca. Now if the kernel design forces the
> automatic loading of dst, dst-ca and dst-ci, every attempt of discussion
> about debug parameters is simply obsolete! So if I cannot load the dst
> module separately, how should I be able to hack in
> debug parameters? I know what debug parameters are for, and I deeply
> respect
> developers work, but what the hell is it all worth for if a kernel design
> suppresses hacking in debug parameters?
> 2. Moreover I am not shure in how far the parameters 0x68 and 0x71 really
> correspond to TwinHan cards. A closer look to CARDLIST.bttv says: card ID
> =
> 113. But perhaps I have problems to deal with hexadecimal numbers, and
> this
> would simply be my problem, not yours!
> 
> 4 rules for a real good documentation:
> 1. understandable and transparent information for different understanding
> levels
> 2. strictly corresponding to the laws of the current kernel design
> 3. absolutely errorfree concerning orthographic junk
> 4. structured in a senseful manner (f. ex.: headliner corresponds to real
> contents)
> 
> If an attempt of documentation lacks at least one of the four, it is
> simply
> useless to my opinion. Why aren't debug parameters part of another part of
> documentation, f. ex. ci.txt? Or ca.txt? The headline of dvb-bt8xx.txt
> goes:
> "How to get the Nebula, PCTV, and TwinHan DST cards working."
> My question: If the essence of a documentation text is how to bring up a
> specified card, then please what the hell has that got to do with debug
> parameters? Who are the addressed groups of such a text? To my opinion at
> least the headliner says that the following text addresses users and
> nobody
> else!
> So I simply never intended to bypass any developer, but I simply found out
> that the bt8xx-documentation simply did not correspond to the actual
> kernel
> design. In other words: Was unusable. So I decided to write a patch and
> simply act instead of performing endless discussions, and that's all about
> it!
> And: If you reinvent the name of cards: Do it for whatever reason, for
> god's
> sake! But: How the hell do you define to a person not convenient with all
> that special technical vocabulary, what the hell a BT8xx-card is? Remember
> the first of my 4 rules (see above!). So at least a complete list of cards
> conforming to that standard is necessary for transparent information:
> Question: Pinnacle PCTV SAT, Nebula Electronics DigiTV, TwinHan DST and
> clones, Avermedia of all kinds..... Is that list complete? If not, please
> drop me a note where I can get that complete list of cards corresponding
> to
> that standard, and I'll instantly sit down and write a patch to improve
> documentation.
> But before I even think about doing that I appreciate you to do your
> homework:
> a. readd my name (I didn't delete it, so I won't do the same job again,
> not
> for sync reasons, and not for reasons of lack of time, and not for any
> other
> reason.
> b. fix orthographic errors in dvb-bt8xx.txt (for the same reason mentioned
> in point a.)
> c. reconstruct my 2.6.13-structure of dvb-bt8xx.txt as far as possible
> d. reflect very well, whether debug parameters should not better be
> situated
> in different documentation texts (logically structured, understandable)
> 
> Regards
> 
> Uwe Bugla
> 
> P. S.: akpm never complains about lack of time, and he is doing a very
> fair
> and good job, and, at least for him, the amount of 54 patches is simply
> peanuts. I love cooperation with guys like him!
> In other words: I respect the demand that cvs-tree and current kernel must
> be in sync somehow, but if the output is rubbish for several reasons and,
> moreover, neglects my work, there is simply no reason for any kind of
> respect. Because I ain't no idiot, just to say it in very simple words.
> So please in future avoid to blame my person for things that you
> personally
> don't get worked (synchronization or whatever kind).
> And would you please answer me one question: How can I be shure that my
> patchwork at least enters the institution akpm, if there is someone like
> you
> in between complaining for lack of time and synchronization faults? I
> prefer
> flat hierarchies (the real hidden success principle of Linux) and
> cooperation with akpm works very fine.
> So, as a matter of principle, I don't see any reason why I should prepare
> and send in my work three, four, five times, just because at the other end
> someone doesn't get his stuff synchronized or lacks time. I ain't no
> idiot!
> Ya Basta!
> And even if I would give in now for strategic reasons and do the same
> fuckin' work again, how many Stezenbach clones or whoever would come up
> afterwards and continue to fuck up my work in the same or just in a
> different way you personally did? Who do you think you are and who do you
> think I am? So please do your homework, and do it correct in the future,
> or
> leave that job simply to another person. OK?
> Any further questions, Mr. Johannes Stezenbach?
> 
> -- 
> Lust, ein paar Euro nebenbei zu verdienen? Ohne Kosten, ohne Risiko!
> Satte Provisionen für GMX Partner: http://www.gmx.net/de/go/partner
> 
> Hallo Mr. Stezenbach,
> 
> "You breached the protocol by not sending the patches to the maintainer
> or linux-dvb list. The result of this was that we had conflicting
> changes in CVS. I spent about 10 minutes thinking how I could
> merge the two, and then gave up (I had 53 other patches to prepare
> and I had little time left to do the job). So I didn't just remove
> your name, but all changes which you sent to akpm along with it.
> bt8xx.txt in the kernel is now in sync with the version in linuxtv.org
> CVS."
> 
> I didn't breach any protocol, nor did I break any unwritten rule or law. I
> simply took the advice from Gerd Knorr that linuxtv maintainers were just
> moving to another place to the point of time when I sent in my first
> dvb-bt8xx-patch. So consequently I took the direct way to send it to akpm.
> Just to be sure it is really being applied without waiting 3, 4 weeks or
> however long. So if you continue to at least discussing with my person,
> please immediately stop doing that in such a bureaucratic manner. If
> synchronization of CVS and kernel.org only works unidirectional, and not
> bidirectional, then neither I, nor akpm, nor Manu or anybody else has a
> real
> problem, but you personally have one without any doubts.
> And if you lack time, simply delegate your job to another person. But
> simply
> stop rubbing out other peoples coauthorship and pay respect to their
> contributions. And the biggest joke about your personal misbehaviour is
> the
> fact that you personally cosigned at least one of my patch attempts,
> without
> dropping me a single note asking me to not bypass the linuxtv CVS
> maintainers. So good morning Mr. Stezenbach, I appreciate you to wake up a
> little bit earlier in the future!
> 
> "Additionally you deleted information from bt8xx.txt which I think were
> useful help for debugging problems, and which were written there on
> purpose
> by the developer. So if you talk about respect, you could show some
> yourself
> by not bypassing the original authors and maintainers when sending
> patches."
> 
> In fact I did, and I can tell you the simple reasons why.
> There are in fact two things that I simply cannot and will not tolerate:
> a. orthographic junk (examples: "bythe" or, even worse: "autodected" and
> "Recognise") It was ME who corrected that in the past, and it was YOU
> personally who reversed that, if not to say: fucked it up in the current
> 2.6.14-rc1. So as a consequence it is YOUR task to do your homework and
> apologize for that, but not MINE!
> b. attempts of documentation that do NOT correspond to their appropriate
> kernel design
> What do I mean with b.?
> 1. In Kernels 2.6.12 AND 2.6.13 the simple command "modprobe dvb-bt8xx"
> caused ALL OTHER modules to load automatically:
> cx24110, dst, dst-ci and dst-ca. Now if the kernel design forces the
> automatic loading of dst, dst-ca and dst-ci, every attempt of discussion
> about debug parameters is simply obsolete! So if I cannot load the dst
> module separately, how should I be able to hack in
> debug parameters? I know what debug parameters are for, and I deeply
> respect
> developers work, but what the hell is it all worth for if a kernel design
> suppresses hacking in debug parameters?
> 2. Moreover I am not shure in how far the parameters 0x68 and 0x71 really
> correspond to TwinHan cards. A closer look to CARDLIST.bttv says: card ID
> =
> 113. But perhaps I have problems to deal with hexadecimal numbers, and
> this
> would simply be my problem, not yours!
> 
> 4 rules for a real good documentation:
> 1. understandable and transparent information for different understanding
> levels
> 2. strictly corresponding to the laws of the current kernel design
> 3. absolutely errorfree concerning orthographic junk
> 4. structured in a senseful manner (f. ex.: headliner corresponds to real
> contents)
> 
> If an attempt of documentation lacks at least one of the four, it is
> simply
> useless to my opinion. Why aren't debug parameters part of another part of
> documentation, f. ex. ci.txt? Or ca.txt? The headline of dvb-bt8xx.txt
> goes:
> "How to get the Nebula, PCTV, and TwinHan DST cards working."
> My question: If the essence of a documentation text is how to bring up a
> specified card, then please what the hell has that got to do with debug
> parameters? Who are the addressed groups of such a text? To my opinion at
> least the headliner says that the following text addresses users and
> nobody
> else!
> So I simply never intended to bypass any developer, but I simply found out
> that the bt8xx-documentation simply did not correspond to the actual
> kernel
> design. In other words: Was unusable. So I decided to write a patch and
> simply act instead of performing endless discussions, and that's all about
> it!
> And: If you reinvent the name of cards: Do it for whatever reason, for
> god's
> sake! But: How the hell do you define to a person not convenient with all
> that special technical vocabulary, what the hell a BT8xx-card is? Remember
> the first of my 4 rules (see above!). So at least a complete list of cards
> conforming to that standard is necessary for transparent information:
> Question: Pinnacle PCTV SAT, Nebula Electronics DigiTV, TwinHan DST and
> clones, Avermedia of all kinds..... Is that list complete? If not, please
> drop me a note where I can get that complete list of cards corresponding
> to
> that standard, and I'll instantly sit down and write a patch to improve
> documentation.
> But before I even think about doing that I appreciate you to do your
> homework:
> a. readd my name (I didn't delete it, so I won't do the same job again,
> not
> for sync reasons, and not for reasons of lack of time, and not for any
> other
> reason.
> b. fix orthographic errors in dvb-bt8xx.txt (for the same reason mentioned
> in point a.)
> c. reconstruct my 2.6.13-structure of dvb-bt8xx.txt as far as possible
> d. reflect very well, whether debug parameters should not better be
> situated
> in different documentation texts (logically structured, understandable)
> 
> Regards
> 
> Uwe Bugla
> 
> P. S.: akpm never complains about lack of time, and he is doing a very
> fair
> and good job, and, at least for him, the amount of 54 patches is simply
> peanuts. I love cooperation with guys like him!
> In other words: I respect the demand that cvs-tree and current kernel must
> be in sync somehow, but if the output is rubbish for several reasons and,
> moreover, neglects my work, there is simply no reason for any kind of
> respect. Because I ain't no idiot, just to say it in very simple words.
> So please in future avoid to blame my person for things that you
> personally
> don't get worked (synchronization or whatever kind).
> And would you please answer me one question: How can I be shure that my
> patchwork at least enters the institution akpm, if there is someone like
> you
> in between complaining for lack of time and synchronization faults? I
> prefer
> flat hierarchies (the real hidden success principle of Linux) and
> cooperation with akpm works very fine.
> So, as a matter of principle, I don't see any reason why I should prepare
> and send in my work three, four, five times, just because at the other end
> someone doesn't get his stuff synchronized or lacks time. I ain't no
> idiot!
> Ya Basta!
> And even if I would give in now for strategic reasons and do the same
> fuckin' work again, how many Stezenbach clones or whoever would come up
> afterwards and continue to fuck up my work in the same or just in a
> different way you personally did? Who do you think you are and who do you
> think I am? So please do your homework, and do it correct in the future,
> or
> leave that job simply to another person. OK?
> Any further questions, Mr. Johannes Stezenbach?
> 
> -- Lust, ein paar Euro nebenbei zu verdienen? Ohne Kosten, ohne Risiko!
> Satte Provisionen für GMX Partner: http://www.gmx.net/de/go/partner

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
