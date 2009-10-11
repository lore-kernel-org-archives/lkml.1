Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZJKXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZJKXKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZJKXKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:10:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58112 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZJKXE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:04:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Chiang" <achiang@hp.com>, "Alex Chiang" <achiang@hp.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "chepioq" <chepioq@gmail.com>,
       "Len Brown" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.wLE.f0l0KB@chimera>
Subject: [Bug #14129] 2.6.31 regression - pci_get_slot oops, udev boot hang - toshiba X200
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14129
Subject		: 2.6.31 regression - pci_get_slot oops, udev boot hang - toshiba X200
Submitter	: chepioq <chepioq@gmail.com>
Date		: 2009-09-06 07:01 (36 days old)
Handled-By	: Alex Chiang <achiang@hp.com>
		  Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://patchwork.kernel.org/patch/51834/


