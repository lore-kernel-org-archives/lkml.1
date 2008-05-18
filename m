Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYERMTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYERMTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbYERMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759323AbYERMN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:28 -0400
Cc: "Lin Ming" <ming.m.lin@intel.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.GY.vsBMIB@albercik>
Subject: [Bug #10669] ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (13 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>


