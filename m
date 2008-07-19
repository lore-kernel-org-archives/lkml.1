Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYGSTal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYGSTal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYGSTad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:30:33 -0400
Received: from smtp02.uc3m.es ([163.117.176.132]:48724 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYGSTac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:30:32 -0400
Date: Sat, 19 Jul 2008 21:30:27 +0200
Message-Id: <200807191930.m6JJURC12038@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <20080719080002.GA11272@isi.edu>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-11.4750 TC:1F TRN:29 TV:5.5.1026(16042.001)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080719080002.GA11272@isi.edu> you wrote:
> In <200807180823.m6I8NIo27365@inv.it.uc3m.es>, Peter T. Breuer
> proposed switching to a three-level numbering scheme and resetting the
> middle number when useful [which I suppose might mean a major feature
> change or just a desire to avoid largish meaningless numbers].  I
> assume this sould give a sequence like:

> 2.6.26.s, 2.8.s, 2.9.s, 2.10.s,

Actually he said

   rename 2.6.28 to 2.8.0
or 
   rename 2.6.29 to 2.9.0
or
   rename 2.6.30 to 3.0.0

i.e. .. whatever you are doing now, just drop the first two numbers (the
"2.6" bit) since they seem to be constant.

I don't know where the idea you propose above came from, and I don't
quite understand it either!

Remember that Linus' only objective is to have smaller numbers, which
may therefore

 1) be memorable
 2) be good advertising copy
 3) be meaningful

and that was the only intention of my scheme: "drop the constant bit".

Peter
