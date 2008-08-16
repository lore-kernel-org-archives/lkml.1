Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYHPUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYHPUl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYHPUdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbYHPUdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
Subject: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11313
Subject		: Plugging HDMI causes "unable to handle kernel paging request"
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2008-08-12 14:30 (5 days old)


