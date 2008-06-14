Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYFNVUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYFNVUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYFNVTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50277 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbYFNVTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:47 -0400
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.DrF.wLDVIB@albercik>
Subject: [Bug 10642] general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (39 days old)
References	: http://lkml.org/lkml/2008/5/7/48


