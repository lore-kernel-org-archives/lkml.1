Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYFVTHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYFVTHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYFVTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYFVTFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:04 -0400
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.6mG.OxpXIB@albercik>
Subject: [Bug #10629] 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (49 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


