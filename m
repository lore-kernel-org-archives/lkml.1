Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520Ab0AJXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0AJXF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050Ab0AJXFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:05:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab0AJXFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:05:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Gertjan van Wingerde" <gwingerde@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.1GC.1glSLB@chimera>
Subject: [Bug #14896] REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14896
Subject		: REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
Submitter	: Alan Stern <stern@rowland.harvard.edu>
Date		: 2009-12-06 22:12 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=126013756829691&w=4
Handled-By	: Gertjan van Wingerde <gwingerde@gmail.com>
Patch		: http://patchwork.kernel.org/patch/67338/


