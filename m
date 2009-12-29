Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZL2Phv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZL2Phv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZL2PfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:35:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZL2PfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:35:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Gertjan van Wingerde" <gwingerde@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.G2B.QwhOLB@chimera>
Subject: [Bug #14896] REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:53 +0100 (CET)
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
Date		: 2009-12-06 22:12 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=126013756829691&w=4
Handled-By	: Gertjan van Wingerde <gwingerde@gmail.com>


