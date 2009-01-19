Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbZATANG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbZATANG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbZATAFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:05:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZATAFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:05:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Caleb Cushing" <xenoterracide@gmail.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.SID.GKRdJB@chimera>
Subject: [Bug #12264] i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12264
Subject		: i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Submitter	: Caleb Cushing <xenoterracide@gmail.com>
Date		: 2008-12-16 11:40 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=122942777030666&w=4


