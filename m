Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYF2TdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYF2TdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbYF2TbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbYF2TbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:20 -0400
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Johannes Weiner" <hannes@saeurebad.de>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.EyF.Q99ZIB@albercik>
Subject: [Bug #10741] bug in `tty: BKL pushdown'?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
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
Date		: 2008-05-18 2:16 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
		  http://lkml.org/lkml/2008/6/16/104
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


