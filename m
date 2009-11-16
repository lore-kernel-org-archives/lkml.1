Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZKPXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZKPXVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZKPXUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:20:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526AbZKPXQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:13 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stephan von Krawczynski" <skraw@ithnet.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.w9C.NodALB@chimera>
Subject: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:18 +0100 (CET)
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
Date		: 2009-09-20 11:26 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4


