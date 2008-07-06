Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYGFNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYGFNN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYGFNC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:02:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbYGFNBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.XLC.s0LcIB@albercik>
Subject: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
		  http://lkml.org/lkml/2008/6/15/117
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


