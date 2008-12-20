Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYLUA0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYLUA0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYLUAZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:25:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYLUAZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:25:50 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Soeren Sonnenburg" <kernel@nn7.de>
References: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
In-Reply-To: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CMMRhk39O-L.A.xND.FlYTJB@chimera>
Subject: [Bug #11698] 2.6.27-rc7, freezes with more than 1 s2ram cycle
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
Subject		: 2.6.27-rc7, freezes with more than 1 s2ram cycle
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-09-29 11:29 (83 days old)
References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


