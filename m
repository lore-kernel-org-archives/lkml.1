Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYFNVT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYFNVT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYFNVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbYFNVTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:45 -0400
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.twF.HMDVIB@albercik>
Subject: [Bug 10629] 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:01 +0200 (CEST)
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
Date		: 2008-05-05 09:59 (41 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


