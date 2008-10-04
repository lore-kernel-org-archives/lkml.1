Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYJDT16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYJDT16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYJDTTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:19:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbYJDTTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:19:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.itG.Y475IB@wind>
Subject: [Bug #11696] 2.6.27-rc8 doubled times
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11696
Subject		: 2.6.27-rc8 doubled times
Submitter	: Hugh Dickins <hugh@veritas.com>
Date		: 2008-10-03 10:21 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122302939313636&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://marc.info/?l=linux-kernel&m=122307260621434&w=4


