Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYHWTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYHWTtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYHWTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:42:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbYHWTmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:42:24 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.q9H.6aGsIB@albercik>
Subject: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11342
Subject		: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Submitter	: Alan D. Brunelle <Alan.Brunelle@hp.com>
Date		: 2008-08-13 23:03 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121866876027629&w=4
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


