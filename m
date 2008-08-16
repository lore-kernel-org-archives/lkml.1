Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYHPUoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYHPUoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYHPUds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbYHPUdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:46 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, "Robin Holt" <holt@sgi.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.0cE.OazpIB@albercik>
Subject: [Bug #11338] ia64 allmodconfig on current mainline
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11338
Subject		: ia64 allmodconfig on current mainline
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-08-12 22:06 (5 days old)
References	: http://marc.info/?l=linux-ia64&m=121857881314455&w=4
Handled-By	: Luck, Tony <tony.luck@intel.com>
		  Robin Holt <holt@sgi.com>


