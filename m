Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYJYWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYJYWEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYJYV7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:59:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbYJYV7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:59:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
In-Reply-To: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t1C3RWL0r7M.A.wYB.UV5AJB@chimera>
Subject: [Bug #11854] v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 22:06:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11854
Subject		: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-10-25 17:14 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122495490201663&w=4


