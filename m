Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXJUCWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXJUCWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXJUCWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:22:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44867 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXJUCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:21:59 -0400
Date: Sat, 20 Oct 2007 17:54:35 -0400
Message-Id: <200710202154.l9KLsZoF005751@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: what to call it after 2.6.23 but before 2.6.24-rc1?
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, is there a preferred name to refer to the kernel version in your tree
after 2.6.23 is out (and the official 2.6.23.y git was created) but before
you release 2.6.24-rc1?  I've seen online references to it as "2.6.24",
"2.6.24++", "2.6.24-rc0", etc.  Since your top-level Makefile still says
"2.6.23", it is sometimes a bit confusing when one is testing code against
your tree as well as the previously released stable kernel.  I usually will
stick a localversion file in my cloned copy of your tree, saying
"2.6.24-pre-rc" or so.  Perhaps you can come up with a definitive name for
this "limbo" state and put it in your Makefile?

Anyway, 'tis just a minor quibble (which I hope won't start yet another
major "naming" flame war :-0

Thanks,
Erez.
