Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZFGNAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZFGNAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZFGMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbZFGMzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>, "Keith Packard" <keithp@keithp.com>,
       "Santi" <santi@agolina.net>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.iaG.BZ7KKB@chimera>
Subject: [Bug #13462] Unused bands in intefb console and smaller 180x56 -> 128x48
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13462
Subject		: Unused bands in intefb console and smaller 180x56 -> 128x48
Submitter	: Santi <santi@agolina.net>
Date		: 2009-06-05 16:30 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9fb15f60eb517c958dec64dca9357bf62bf2201
Handled-By	: Keith Packard <keithp@keithp.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=13462#c2


