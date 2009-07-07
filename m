Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZGGAT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZGGAT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZGGAKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:10:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367AbZGGAKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:10:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Dave Jones" <davej@redhat.com>, "Jarek Poplawski" <jarkao2@gmail.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.usG.AApUKB@chimera>
Subject: [Bug #13647] fb/mmap lockdep report.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13647
Subject		: fb/mmap lockdep report.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2009-06-21 13:33 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=513adb58685615b0b1d47a3f0d40f5352beff189
References	: http://lkml.org/lkml/2009/6/21/90
		  http://lkml.org/lkml/2009/6/21/122


