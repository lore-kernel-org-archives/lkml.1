Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYDHXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYDHXsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYDHXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:48:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYDHXsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:48:24 -0400
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Soeren Sonnenburg" <kernel@nn7.de>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.e3F.yBA_HB@albercik>
Subject: [Bug #10093] 2.6.25-current-git blocks for 10-15 secs on boot unless CONFIG_CPU_IDLE=n - Apple
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
Subject		: 2.6.25-current-git blocks for 10-15 secs on boot unless CONFIG_CPU_IDLE=n - Apple
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (46 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
		  http://lkml.org/lkml/2008/4/5/34
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://marc.info/?l=linux-kernel&amp;m=120674502201007&amp;w=4


