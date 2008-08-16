Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYHPUeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYHPUeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYHPUcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:32:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbYHPUb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:31:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.9xG.LczpIB@albercik>
Subject: [Bug #11224] Only three cores found on quad-core machine.
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


