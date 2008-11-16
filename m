Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYKPSpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYKPSpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYKPSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbYKPSfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       "Frans Pop" <elendil@planet.nl>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Kay Sievers" <kay.sievers@vrfy.org>, "Len Brown" <len.brown@intel.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.psD.BAGIJB@chimera>
Subject: [Bug #12049] Oops in acpi_system_wakeup_device_seq_show
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12049
Subject		: Oops in acpi_system_wakeup_device_seq_show
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2008-11-16 13:04 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0794469da3f7b2093575cbdfc1108308dd3641ce
References	: http://marc.info/?l=linux-kernel&m=122684070215520&w=4


