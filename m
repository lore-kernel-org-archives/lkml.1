Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZGZXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZGZXUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZGZXUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:20:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZGZXUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:20:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Rosenboom" <jens@mcbone.net>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.AhB.CHObKB@chimera>
Subject: [Bug #13842] Oops when writing to /sys/block/ram0/queue/max_sectors_kb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13842
Subject		: Oops when writing to /sys/block/ram0/queue/max_sectors_kb
Submitter	: Jens Rosenboom <jens@mcbone.net>
Date		: 2009-07-23 15:30 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=124836574403032&w=4


