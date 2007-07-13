Return-Path: <linux-kernel-owner+w=401wt.eu-S935600AbXGMTSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935600AbXGMTSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXGMTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:17:56 -0400
Received: from dns.hk.18mail.cn ([210.245.210.181]:54876 "EHLO
	hkm1.server.hk.18mail.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbXGMTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:17:56 -0400
X-Greylist: delayed 1604 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 15:17:56 EDT
Message-ID: <4697C980.1040902@zh-kernel.org>
Date: Sat, 14 Jul 2007 02:50:40 +0800
From: TripleX Chung <triplex@zh-kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Ask for help, about the trivial patches.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on the chinese translated version of
Documentation/SubmittingPatches and get some problem about the "Trivial
patches".I can not understand what "Trivial patches" exactly means.The
documentation said:

Trivial patches must qualify for one of the following rules:

 Spelling fixes in documentation
 //Understand

 Spelling fixes which could break grep(1)
 //Is there any wrong spelling won't break grep(1)?

 Warning fixes (cluttering with useless warnings is bad)
 //Understand

 Compilation fixes (only if they are actually correct)
 //Understand

 Runtime fixes (only if they actually fix things)
 //What kind of runtime fixes? Could anyone give some examples?

 Removing use of deprecated functions/macros (eg. check_region)
 //Understand

 Contact detail and documentation fixes
 //Means Contact detail fixes and documentation fixes, right?
   Are all the documentation fixes "trivial"?

 Non-portable code replaced by portable code (even in arch-specific,
 since people copy, as long as it's trivial)
 //Do not understand the words in the brackets.

 Any fix by the author/maintainer of the file (ie. patch monkey
 in re-transmission mode)
 //It means if I am the author of a file, when I modify the file, the
patch is trivial, right?

Please give me some advice. Thanks in advance.

