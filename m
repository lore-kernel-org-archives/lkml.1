Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYJDT0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYJDT0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYJDTTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:19:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbYJDTTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:19:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?P=C3=A4r=20Andersson?= <paran@lysator.liu.se>,
       "Tejun Heo" <tj@kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.kHH.u475IB@wind>
Subject: [Bug #11615] sata_nv EH problems
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11615
Subject		: sata_nv EH problems
Submitter	: Pär Andersson <paran@lysator.liu.se>
Date		: 2008-09-21 18:09 (14 days old)
Handled-By	: Tejun Heo <tj@kernel.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18078&action=view


