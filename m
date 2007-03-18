Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXCRStK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXCRStK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXCRStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:49:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34314 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932819AbXCRStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:49:07 -0400
Date: Sun, 18 Mar 2007 19:49:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>
Subject: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070318184908.GU752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : weird system hangs
References : http://lkml.org/lkml/2007/3/16/288
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
             Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Status     : unknown


Subject    : crashes in KDE
References : http://bugzilla.kernel.org/show_bug.cgi?id=8157
Submitter  : Oliver Pinter <oliver.pntr@gmail.com>
Status     : unknown


Subject    : kwin dies silently
References : http://lkml.org/lkml/2007/2/28/112
Submitter  : Sid Boyce <g3vbv@blueyonder.co.uk>
Status     : unknown

