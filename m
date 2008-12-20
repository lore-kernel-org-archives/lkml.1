Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYLUA0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYLUA0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYLUAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:25:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbYLUAZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:25:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
References: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
In-Reply-To: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CMMRhk39O-L.A.LUD.klYTJB@chimera>
Subject: [Bug #11569] Panic stop CPUs regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:16:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
Subject		: Panic stop CPUs regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-09-02 13:49 (110 days old)
References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4


