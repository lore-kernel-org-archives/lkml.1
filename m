Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGFX64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGFX64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZGFX5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZGFX47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:56:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Matthew Wilcox" <matthew@wil.cx>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.HoE.b0oUKB@chimera>
Subject: [Bug #13673] HIGHMEM64G causes hang in PCI init on 32-bit x86
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13673
Subject		: HIGHMEM64G causes hang in PCI init on 32-bit x86
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-06-26 15:59 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=95ee14e4379c5e19c0897c872350570402014742
References	: http://marc.info/?l=linux-pci&m=124615181602643&w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


