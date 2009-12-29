Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZL2PSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZL2PSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZL2PR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:17:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZL2POh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:14:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Gene Heskett" <gene.heskett@verizon.net>, "okias" <d.okias@gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.-nG.JnhOLB@chimera>
Subject: [Bug #14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2009-12-26 14:13 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4


