Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYHPUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYHPUc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYHPUbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:31:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37226 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYHPUbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:31:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.2aH.xczpIB@albercik>
Subject: [Bug #11205] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11205
Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-07-30 11:02 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121741584608240&w=4
Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
Patch		: http://marc.info/?l=linux-kernel&m=121742199419686&w=2


