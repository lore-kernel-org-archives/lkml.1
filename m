Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZBNXYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZBNXYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZBNXTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:19:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbZBNXTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:19:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frank Groeneveld" <frankgroeneveld@gmail.com>,
       "Pavel Machek" <pavel@suse.cz>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.hb.C50lJB@chimera>
Subject: [Bug #12407] Kernel 2.6.28 regression: Hang after hibernate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12407
Subject		: Kernel 2.6.28 regression: Hang after hibernate
Submitter	: Frank Groeneveld <frankgroeneveld@gmail.com>
Date		: 2008-12-28 20:34 (49 days old)
References	: http://marc.info/?l=linux-kernel&m=123049651906081&w=4


