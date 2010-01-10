Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731Ab0AJWxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0AJWxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651Ab0AJWxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:53:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab0AJWxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:53:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@linux.intel.com>, "Deepak Saxena" <dsaxena@laptop.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Sascha Hauer" <s.hauer@pengutronix.de>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.1vE.HklSLB@chimera>
Subject: [Bug #14297] console resume broken since ba15ab0e8d
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:46:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (103 days old)
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


