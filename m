Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYILUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYILUq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbYILUoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:44:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbYILUoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:44:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.W3.8esyIB@albercik>
Subject: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


