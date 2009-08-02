Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZHBWH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZHBWH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZHBWBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:01:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbZHBWBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:01:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jan Scholz" <scholz@fias.uni-frankfurt.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.JgG.PrgdKB@chimera>
Subject: [Bug #13407] adb trackpad disappears after suspend to ram
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
Subject		: adb trackpad disappears after suspend to ram
Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date		: 2009-05-28 7:59 (67 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


