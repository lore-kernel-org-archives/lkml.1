Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZGZX1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZGZX1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZGZX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:27:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbZGZXRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:17:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "Tarkan Erimer" <tarkan.erimer@turknet.net.tr>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.QJF.WIObKB@chimera>
Subject: [Bug #13657] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13657
Subject		: Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Submitter	: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Date		: 2009-06-26 10:03 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3821d768912a47ddbd6cab52943a8284df88003c
References	: http://lkml.org/lkml/2009/6/26/34
Handled-By	: Martin K. Petersen <martin.petersen@oracle.com>


