Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYGSXLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYGSXLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 19:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYGSXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 19:10:52 -0400
Received: from smtp01.uc3m.es ([163.117.176.131]:42362 "EHLO smtp01.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYGSXKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 19:10:52 -0400
Date: Sun, 20 Jul 2008 01:10:48 +0200
Message-Id: <200807192310.m6JNAmN03740@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: Craig Milo Rogers <rogers@ISI.EDU>, linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <20080719211653.GF18350@isi.edu>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-9.6870 TC:1F TRN:30 TV:5.5.1026(16042.002)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Craig Milo Rogers <rogers@isi.edu> wrote:
>>    rename 2.6.28 to 2.8.0
>> or 
>>    rename 2.6.29 to 2.9.0
>> or
>>    rename 2.6.30 to 3.0.0
>> 
>> i.e. .. whatever you are doing now, just drop the first two numbers (the
>> "2.6" bit) since they seem to be constant.

> 	So you're saying that the formula is to drop the "2.6" and place
> a period between the first and sedond digits of what's currently the
> release number? OK, I hadn't interpreted it that way.  Does the sequence
> continue like this?

The point is to rebase to a new system at a point coming up which is
convenient.  There is an opportunity at 2.6.28, which can be renamed
2.8.0, dropping the constant 2.6.

I suppose one counts 2.8.1, 2.8.2 from then on, or does whatever else
one wants to do.  I don't know - Linus' only objective is to get smaller
more meaningful numbers and the details of how one counts afterwards
don't matter.

Or if one misses the 2.6.28 point, one gets another good opportunity for
rebasing at 2.6.30, which could become 3.0.0, dropping the constant 2.6
again.

>> Remember that Linus' only objective is to have smaller numbers, which
>> may therefore
>> 
>>  1) be memorable
>>  2) be good advertising copy
>>  3) be meaningful
>> 
>> and that was the only intention of my scheme: "drop the constant bit".

> 	And the underlying problem is that there are only so many
> small numbers. 

We need smaller numbers now.

I.e.  We're happy with the system we've got, except for the high
numbers we're at, so just rebase.


Peter
