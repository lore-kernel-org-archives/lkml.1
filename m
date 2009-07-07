Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZGGAHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZGGAHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZGGAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:07:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZGGAHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:07:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "Jerome Glisse" <glisse@freedesktop.org>,
       "Karsten Mehrhoff" <kawime@gmx.de>,
       "=?utf-8?q?Michel=20D=C3=A4nzer?=" <michel@daenzer.net>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.PDB.4BpUKB@chimera>
Subject: [Bug #13318] AGP doesn't work anymore on nforce2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
Subject		: AGP doesn't work anymore on nforce2
Submitter	: Karsten Mehrhoff <kawime@gmx.de>
Date		: 2009-04-30 8:51 (68 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>


