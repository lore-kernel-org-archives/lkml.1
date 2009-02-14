Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZBNXUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZBNXUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbZBNXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:18:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439AbZBNXSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:18:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin Madru" <bevicm@dslextreme.com>,
       "Linux IDE" <linux-ide@vger.kernel.org>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.ahB.b50lJB@chimera>
Subject: [Bug #12263] Sata soft reset filling log
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
Subject		: Sata soft reset filling log
Submitter	: Justin Madru <bevicm@dslextreme.com>
Date		: 2008-12-13 2:07 (64 days old)
References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4


