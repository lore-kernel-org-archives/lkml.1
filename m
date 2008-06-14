Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbYFNV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbYFNV36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYFNVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:20:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYFNVUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:20:20 -0400
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.8UD.1IDVIB@albercik>
Subject: [Bug 10872] x86_64 boot hang when CONFIG_NUMA=n
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


