Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0BHAqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:46:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab0BHAp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:45:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "r4" <mk_4@centrum.cz>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.r0.JZ1bLB@chimera>
Subject: [Bug #14895] BUG in kernel 2.6.32 when using luks encrypted root and RAID0..
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14895
Subject		: BUG in kernel 2.6.32 when using luks encrypted root and RAID0..
Submitter	: r4 <mk_4@centrum.cz>
Date		: 2009-12-03 18:24 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=125986664904751&w=4


