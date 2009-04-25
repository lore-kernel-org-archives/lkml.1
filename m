Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZDYWVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZDYWVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZDYWSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:18:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044AbZDYWSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:18:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Matt Carlson" <mcarlson@broadcom.com>,
       "Michael Chan" <mchan@broadcom.com>, "Robin Holt" <holt@sgi.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.ScE.fd48JB@chimera>
Subject: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13111
Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
Submitter	: Robin Holt <holt@sgi.com>
Date		: 2009-04-08 7:12 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e4f341103e4a2b35f56a0f89802f1b1448e8d04b
References	: http://marc.info/?l=linux-kernel&m=123917477312823&w=4
		  http://lkml.org/lkml/2009/4/16/471
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


