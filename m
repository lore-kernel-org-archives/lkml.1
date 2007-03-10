Return-Path: <linux-kernel-owner+w=401wt.eu-S933491AbXCJQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbXCJQ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933493AbXCJQ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:59:32 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:59500 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933491AbXCJQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:59:31 -0500
Date: Sat, 10 Mar 2007 17:53:11 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andreas Schwab <schwab@suse.de>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Valdis.Kletnieks@vt.edu,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <jeslcdktzh.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.61.0703101752440.8799@yvahk01.tjqt.qr>
References: <1173419792.32234.131.camel@localhost.localdomain>
 <1173481052.32234.137.camel@localhost.localdomain>
 <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
 <1173503968.3104.65.camel@nigel.suspend2.net> <Pine.LNX.4.61.0703101452240.8799@yvahk01.tjqt.qr>
 <jeslcdktzh.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 16:18, Andreas Schwab wrote:
>Jan Engelhardt <jengelh@linux01.gwdg.de> writes:
>
>> So in case they _ARE_ compatible, we get the compile error, as far as I
>> can see it. There's a ! too much in the !!_builtin line.
>

	>The error case is when the types are compatible.  That means that
	>the argument is in fact _not_ an array.

That one should go in as a comment for that macro.



Jan
-- 
