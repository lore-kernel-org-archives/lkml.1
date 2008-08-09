Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYHJAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYHJAWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYHJAKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYHJAKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A._SH.OCjnIB@albercik>
Subject: [Bug #11296] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11296
Subject		: 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-09 21:21 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121831675111794&w=4


