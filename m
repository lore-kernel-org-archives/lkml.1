Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZKUPMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZKUPMC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:12:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZKUPL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:11:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZKUPH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:07:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Eddy=20Petri=C8=99or?=" <eddy.petrisor+linbug@gmail.com>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
In-Reply-To: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l2_yP_tdgYK.A._aD.87_BLB@chimera>
Subject: [Bug #14417] [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 15:51:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
Date		: 2009-10-16 11:07 (37 days old)


