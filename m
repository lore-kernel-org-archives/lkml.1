Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbYGFNKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbYGFNKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbYGFNCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:02:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbYGFNBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?Mathieu=20B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       "Tejun Heo" <htejun@gmail.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.M_.YzLcIB@albercik>
Subject: [Bug #11024] 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11024
Subject		: 2.6.25 to 2.6.26-rc8 regression (related to ahci and acpi _GTF)
Submitter	: Mathieu Bérard <Mathieu.Berard@crans.org>
Date		: 2008-07-01 9:39 (6 days old)
References	: http://marc.info/?t=121490593600001&r=1&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121514631317343&w=4


