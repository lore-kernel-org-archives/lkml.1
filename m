Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZKUPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZKUPHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZKUPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:07:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZKUPHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:07:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Villacis Lasso" <avillaci@ceibo.fiec.espol.edu.ec>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
In-Reply-To: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l2_yP_tdgYK.A.KBE.z8_BLB@chimera>
Subject: [Bug #14331] Radeon XPRESS 200M: System hang with radeon DRI and Fedora 10 userspace unless DRI=off
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 15:51:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14331
Subject		: Radeon XPRESS 200M: System hang with radeon DRI and Fedora 10 userspace unless DRI=off
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2009-10-06 00:29 (47 days old)


