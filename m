Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZCCWGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZCCWGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZCCWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756AbZCCWAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.MVC.EVarJB@chimera>
Subject: [Bug #12762] Disk errors loop forever in 2.6.29
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
Subject		: Disk errors loop forever in 2.6.29
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-19 13:53 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4


