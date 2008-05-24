Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbYEXVgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbYEXVgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbYEXVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762619AbYEXVcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:55 -0400
Cc: "Gabriel C" <nix.or.die@googlemail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.12E.nfIOIB@albercik>
Subject: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (17 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10648#c3


