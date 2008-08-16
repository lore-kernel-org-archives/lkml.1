Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYHPUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYHPUlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbYHPUdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbYHPUdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Williamson" <alex.williamson@hp.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Lennert Buytenhek" <buytenh@marvell.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.UVF.mazpIB@albercik>
Subject: [Bug #11316] severe performance regression for iptables nat routing
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11316
Subject		: severe performance regression for iptables nat routing
Submitter	: Alex Williamson <alex.williamson@hp.com>
Date		: 2008-08-12 22:04 (5 days old)
Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11316#c15
		  http://bugzilla.kernel.org/show_bug.cgi?id=11316#c16


