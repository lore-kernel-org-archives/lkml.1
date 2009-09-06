Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZIFU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZIFU33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZIFU31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:29:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498AbZIFU3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:29:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ciprian Docan" <docan@eden.rutgers.edu>,
       "Eric Paris" <eparis@redhat.com>, "Frans Pop" <elendil@planet.nl>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.bEC.EfBpKB@chimera>
Subject: [Bug #14135] NULL pointer dereference in ima_counts_put
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14135
Subject		: NULL pointer dereference in ima_counts_put
Submitter	: Ciprian Docan <docan@eden.rutgers.edu>
Date		: 2009-09-02 13:49 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94e5d714f604d4cb4cb13163f01ede278e69258b
References	: http://marc.info/?l=linux-kernel&m=125190146028116&w=4


