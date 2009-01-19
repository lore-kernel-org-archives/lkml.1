Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbZASXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbZASXyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZASXwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:52:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760456AbZASXwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:52:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Daniel Drake" <dsd@gentoo.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Phil Dibowitz" <phil@ipom.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.pF.59QdJB@chimera>
Subject: [Bug #12422] 2.6.28-git can't resume from str
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12422
Subject		: 2.6.28-git can't resume from str
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-01-10 1:39 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
References	: http://marc.info/?l=linux-kernel&m=123155157909282&w=4
		  http://marc.info/?l=linux-kernel&m=123167815028388&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://lkml.org/lkml/2009/1/13/144


