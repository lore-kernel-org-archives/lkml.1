Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYI0Rqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYI0Rqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYI0RkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYI0RkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "" <jmerkey@wolfmountaingroup.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.TAH.47m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11549]=202.6.27-rc5=20acpi:=20EC=20Storm=20error=20message=20on=20bootup?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11549
Subject		: 2.6.27-rc5 acpi: EC Storm error message on bootup
Submitter	: <jmerkey@wolfmountaingroup.com>
Date		: 2008-09-02 21:27 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=122039255517586&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18047&action=view


