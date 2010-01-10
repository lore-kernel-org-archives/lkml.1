Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0AJXLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0AJXLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846Ab0AJXEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:04:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0AJXEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:04:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Miles Lane" <miles.lane@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.BlD.ZilSLB@chimera>
Subject: [Bug #14624] ath9k: BUG kmalloc-8192: Poison overwritten
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14624
Subject		: ath9k: BUG kmalloc-8192: Poison overwritten
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-11-12 4:58 (60 days old)
References	: http://marc.info/?l=linux-kernel&m=125800196520396&w=4


