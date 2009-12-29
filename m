Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZL2Pjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZL2Pjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZL2Pec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:34:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZL2PeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Author: Mike Galbraith" <efault@gmx.de>, "Ingo Molnar" <mingo@elte.hu>,
       "=?utf-8?q?M=C3=A1rton=20N=C3=A9meth?=" <nm127@freemail.hu>,
       "Mike Galbraith" <efault@gmx.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.MyC.uwhOLB@chimera>
Subject: [Bug #14794] IP address assigned by DHCP is dropped after ~40 seconds
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
Subject		: IP address assigned by DHCP is dropped after ~40 seconds
Submitter	: Márton Németh <nm127@freemail.hu>
Date		: 2009-12-13 08:59 (17 days old)


