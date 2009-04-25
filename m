Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZDYWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZDYWV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZDYWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:18:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZDYWSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:18:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Mike Galbraith" <efault@gmx.de>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.CQE.cd48JB@chimera>
Subject: [Bug #13114] USB storage (usbstick) automount woes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13114
Subject		: USB storage (usbstick) automount woes
Submitter	: Mike Galbraith <efault@gmx.de>
Date		: 2009-04-09 9:26 (17 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6e244b6cb1f70e7109381626293cd40a8334ed3
References	: http://marc.info/?l=linux-kernel&m=123926928907568&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


