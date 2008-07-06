Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYGFNBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYGFNBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbYGFNBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775AbYGFNBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Johannes Weiner" <hannes@saeurebad.de>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.U_C.H2LcIB@albercik>
Subject: [Bug #10741] bug in `tty: BKL pushdown'?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
		  http://lkml.org/lkml/2008/6/16/104
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


