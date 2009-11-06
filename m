Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZKFQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZKFQ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbZKFQ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:57:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:36016 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757641AbZKFQ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:57:27 -0500
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       technoboy85@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 06 Nov 2009 17:57:31 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
In-Reply-To: <20091106155937.11d95279@lxorguk.ukuu.org.uk>
Message-ID: <20091106165731.26800@gmx.net>
MIME-Version: 1.0
References: <20091106154911.29400@gmx.net>
 <20091106155937.11d95279@lxorguk.ukuu.org.uk>
Subject: Re: i686 quirk for AMD Geode
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18cyfImIS8c0fzVhQ5PM/pkrchx1tNrqTR+/oQHjX
 C9W1aMZW5y4jL2s/GSN09mVWCcL0+tmRlTVg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: Q2LHfjp4f2IsCfFQSG5ogWB4dWxlc1Yh
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 15:59:37 Alan Cox wrote:
> > Looks good? checkpatch.pl has a very different opinion.
> 
> Firstly please learn to trim your email
No, this email contained comments regarding the code.

If it wasn't riddled with 19 errors (not bad for only 133 lines),
I would have bothered to remove these irrelevant lines.

So this advises goes right out of the window.

> Secondly Ingo knows how to operate checkpatch and trivial style bits
> like that are irrelevant to meaningful discussion about code.

Oh, I'm deeply sorry Sir Cox,
I was unaware of the fact that Ingo is just one of your checkpatch minions!?

There's a document, you should have heard of before,
Documentation/SubmittingPatches and it states: "

4) Style check your changes.

Check your patch for basic style violations, details of which can be
found in Documentation/CodingStyle.  Failure to do so simply wastes
the reviewers time and will get your patch rejected, probably
without even being read.

At a minimum you should check your patches with the patch style
checker prior to submission (scripts/checkpatch.pl).  You should
be able to justify all violations that remain in your patch."

Style checks are indeed part of the job of submitting a patch.

It's supposed to make life easier for the Maintainers, so
they only need to add the SOB-line. Instead of wasting their
precious time with really trivia checkpatch.pl fixes.

If you don't like these guidelines,
I'm sure you can call for one of your other
minions e.g. linus to change that for your majesty.

---


Anyway, Matteo Croce reacted quickly and posted a followup.
Well done!
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
