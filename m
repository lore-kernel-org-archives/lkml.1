Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYHPUfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYHPUfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYHPUcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:32:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYHPUcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:32:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Nico Schottelius" <nico@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.b3G.SczpIB@albercik>
Subject: [Bug #11220] Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


