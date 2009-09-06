Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZIFUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZIFUc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbZIFUcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:32:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491AbZIFU25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:28:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hannes Reinecke" <hare@suse.de>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.wtC.dfBpKB@chimera>
Subject: [Bug #14017] _end symbol missing from Symbol.map
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14017
Subject		: _end symbol missing from Symbol.map
Submitter	: Hannes Reinecke <hare@suse.de>
Date		: 2009-08-13 6:45 (25 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=091e52c3551d3031343df24b573b770b4c6c72b6
References	: http://marc.info/?l=linux-kernel&m=125014649102253&w=4
Handled-By	: Hannes Reinecke <hare@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=125014649102253&w=4


