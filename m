Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZFGNMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZFGNMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZFGNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:07:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbZFGNHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:07:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Jeffrey Kirsher" <jeffrey.t.kirsher@intel.com>,
       "Richard Atterer" <richard@2009.atterer.net>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
In-Reply-To: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AN6kEAA5GQ.A.GSB.0j7KKB@chimera>
Subject: [Bug #13371] s2disk hangs with e100, kernel 2.6.29 and later
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 12:06:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
Subject		: s2disk hangs with e100, kernel 2.6.29 and later
Submitter	: Richard Atterer <richard@2009.atterer.net>
Date		: 2009-05-16 22:51 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=Unknown
References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
		  http://lkml.org/lkml/2009/5/25/253
Handled-By	: Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>


