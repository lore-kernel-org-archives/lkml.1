Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZL2PgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZL2PgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZL2PgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:36:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZL2Pfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:35:31 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.9KB.GwhOLB@chimera>
Subject: [Bug #14926] ucc_geth broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14926
Subject		: ucc_geth broken
Submitter	: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Date		: 2009-12-23 17:40 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=126159003430429&w=4
Handled-By	: Anton Vorontsov <avorontsov@ru.mvista.com>
Patch		: http://patchwork.kernel.org/patch/69585/
		  http://patchwork.kernel.org/patch/69600/


