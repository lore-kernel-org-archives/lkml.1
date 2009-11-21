Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZKUPS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZKUPS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZKUPSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:18:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZKUPSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:18:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stephan von Krawczynski" <skraw@ithnet.com>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
In-Reply-To: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mYW9sxtWd2G.A._BG.uDACLB@chimera>
Subject: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 16:02:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
Date		: 2009-09-20 11:26 (63 days old)
References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4


