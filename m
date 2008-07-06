Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYGFNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYGFNJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYGFNB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbYGFNBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.rh.LzLcIB@albercik>
Subject: [Bug #11041] All 2.6.26-rcX hang immediately after loading ohci_hcd
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11041
Subject		: All 2.6.26-rcX hang immediately after loading ohci_hcd
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-07-05 7:08 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121524504505805&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>


