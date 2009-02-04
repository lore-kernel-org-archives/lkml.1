Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZBDMzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZBDMzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbZBDMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbZBDMtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.ZIG.YvYiJB@chimera>
Subject: [Bug #12508] "powerpc/pci: Reserve legacy regions on PCI" broke my G3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12508
Subject		: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-01-17 22:46 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1f343028d35ba4e88cd4a3c44e0d8b8a84264ee
References	: http://marc.info/?l=linux-kernel&m=123223247325452&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


