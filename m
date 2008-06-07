Return-Path: <linux-kernel-owner+w=401wt.eu-S1765927AbYFGWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765927AbYFGWDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbYFGVsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39018 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYFGVso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:44 -0400
Cc: "Adrian Bunk" <bunk@kernel.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.y3B.B2vSIB@albercik>
Subject: [Bug #10874] blackfin drivers/net/smc91x.c build error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10874
Subject		: blackfin drivers/net/smc91x.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-06-06 09:25 (2 days old)
References	: http://lkml.org/lkml/2008/6/6/278
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		:  revert commit 099c736a470c8080a166e7a089f1e48e15f9947c


