Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYLMTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYLMTGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 14:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYLMTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 14:03:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbYLMTDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 14:03:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <mPGxw39gx6O.A.SY.QRARJB@chimera>
In-Reply-To: <mPGxw39gx6O.A.SY.QRARJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rxtftRqgnaB.A.Di.URARJB@chimera>
Subject: [Bug #12200] BUG: bad unlock balance detected! e1000e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Dec 2008 17:55:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12200
Subject		: BUG: bad unlock balance detected! e1000e
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-12-08 11:24 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122873549700644&w=4
Handled-By	: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Patch		: http://marc.info/?l=linux-kernel&m=122905927102071&w=4


