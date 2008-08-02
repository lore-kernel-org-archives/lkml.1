Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYHBTgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYHBTgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYHBT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbYHBT2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.bMD.rMLlIB@albercik>
Subject: [Bug #11225] mtdsuper.c BLOCK=n compile error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11225
Subject		: mtdsuper.c BLOCK=n compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-01 15:33 (2 days old)
References	: http://lkml.org/lkml/2008/8/1/454
Handled-By	: David Woodhouse <dwmw2@infradead.org>
Patch		: http://lkml.org/lkml/2008/8/1/499


