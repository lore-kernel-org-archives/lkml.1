Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZJAXRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZJAXRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZJAXJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:09:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbZJAXJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:09:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Magnus Damm" <damm@igel.co.jp>, "Magnus Damm" <magnus.damm@gmail.com>,
       "Ondrej Zary" <linux@rainbow-software.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.HjB.JNTxKB@chimera>
Subject: [Bug #14222] Hibernation oopses for the 2nd time with 2.6.31 (won't fit the screen)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14222
Subject		: Hibernation oopses for the 2nd time with 2.6.31 (won't fit the screen)
Submitter	: Ondrej Zary <linux@rainbow-software.org>
Date		: 2009-09-24 14:07 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c7121843685de2bf7f3afd3ae1d6a146010bf1fc


