Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZL2Pmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZL2Pmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZL2Pmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:42:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39237 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZL2Pdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:33:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Federico Chiacchiaretta" <federico.chia@gmail.com>,
       "Len Brown" <len.brown@intel.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.SYD.cxhOLB@chimera>
Subject: [Bug #14667] bisected 2.6.32 regression - Temperatures not correctly detected after suspend - Dell Studio XPS 16 laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14667
Subject		: bisected 2.6.32 regression - Temperatures not correctly detected after suspend - Dell Studio XPS 16 laptop
Submitter	: Federico Chiacchiaretta <federico.chia@gmail.com>
Date		: 2009-11-22 20:42 (38 days old)


