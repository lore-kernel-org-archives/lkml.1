Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbZASXsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbZASXsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZASXrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:47:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZASXrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:47:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.nLB.M-QdJB@chimera>
Subject: [Bug #12399] USB wakeup problem on multiple machines
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:28:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12399
Subject		: USB wakeup problem on multiple machines
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2009-01-08 7:35 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fd9086a518d4f14213a32fe6c9ac17fabebbc1e
References	: http://marc.info/?l=linux-kernel&m=123140019117968&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://marc.info/?l=linux-usb&m=123186456612410&w=4


