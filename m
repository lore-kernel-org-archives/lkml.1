Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZEPWZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZEPWZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZEPWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:16:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbZEPWQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:16:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Francis Moreau" <francis.moro@gmail.com>,
       "netdev" <netdev@vger.kernel.org>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.1mH.WYzDKB@chimera>
Subject: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13328
Subject		: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Submitter	: Francis Moreau <francis.moro@gmail.com>
Date		: 2009-05-03 16:22 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=124136778012280&w=4


