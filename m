Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZL2POv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZL2POv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZL2POm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:14:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZL2POg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:14:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.ibG.GnhOLB@chimera>
Subject: [Bug #14938] Unable to handle kernel paging request in radeon_fence_signaled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14938
Subject		: Unable to handle kernel paging request in radeon_fence_signaled
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:40 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=126192123104047&w=4


