Return-Path: <linux-kernel-owner+w=401wt.eu-S1031126AbXD3TxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031126AbXD3TxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031578AbXD3TxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:53:00 -0400
Received: from s1.cableone.net ([24.116.0.227]:60683 "EHLO S1.cableone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031126AbXD3Tw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:52:58 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 15:52:58 EDT
Message-ID: <61071.84.210.74.57.1177961145.squirrel@peltkore.net>
In-Reply-To: <20070430185747.GF23336@stusta.de>
References: <20070429173500.GA30248@one.firstfloor.org>
    <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
    <20070429180909.GA30604@one.firstfloor.org>
    <20070429214007.9ea12e96.diegocg@gmail.com>
    <20070429201729.GQ3468@stusta.de>
    <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org>
    <20070429210505.GS3468@stusta.de>
    <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org>
    <20070430180952.GC23336@stusta.de>
    <alpine.LFD.0.98.0704301113240.3419@woody.linux-foundation.org>
    <20070430185747.GF23336@stusta.de>
Date: Mon, 30 Apr 2007 21:25:45 +0200 (CEST)
Subject: Re: Linux 2.6.21
From: "Vegard Nossum" <vegard@peltkore.net>
To: "Adrian Bunk" <bunk@stusta.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Diego Calleja" <diegocg@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-IP-stats: Incoming Last 0, First 48, in=793, out=0, spam=0
X-External-IP: 69.92.239.228
X-Abuse-Info: Send abuse complaints to abuse@cableone.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, April 30, 2007 8:57 pm, Adrian Bunk wrote:
> I never expected the reality to be come as white as my ideal or the
> washed things in washing powder ads.

This reminds me very much of what the brilliant computing scientist Edsger
W. Dijkstra more than once wrote:

`Confusing "love of perfection" with "claim of perfection", people will
accuse you of the latter and then blame you for the first.' (EWD709)

Also relevant to the discussion, I think, but in another way, is this:

`One of them is the dogma that striving for perfection is
counterproductive in the sense that it would make software development
much too expensive. But what are the main causes of the soaring costs of
software development? A major cost, in terms of both manpower and
unforeseen delays, is debugging, and one can save a lot by investing more
in preventing the bugs from entering the design in the first place. Since
the errors are so expensive, in general the high-quality design is also by
far the cheaper. Another major cause is that many systems are built on
shifting foundations in the sense that the underlying software of
operating systems and compilers is too shaky to be stable, with the result
that each new release of that underlying software requires possibly
extensive adaptation of what has been built on top of it. Finally, many of
the tools the programmer is supposed to work with are so poorly documented
that they force him to find out by experiment what they might be able to
do for him. Since these experiments can be pretty expensive and
time-consuming and —inductive reasoning being what it is— an educated
guess is the best the poor programmer can hope for, the poor programmer is
really in a miserable position. So here you see three major sources of
cost explosion traced down to someone's assumption that striving for
perfection is counterproductive!' (EWD952)

For the complete documents, see
http://www.cs.utexas.edu/users/EWD/transcriptions/EWD07xx/EWD709.html and
http://www.cs.utexas.edu/users/EWD/transcriptions/EWD09xx/EWD952.html,
respectively.


Regards from Vegard's

