Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbYFGVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbYFGVtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYFGVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYFGVsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:25 -0400
Cc: "Lin Ming" <ming.m.lin@intel.com>, "Ming Lin" <ming.m.lin@intel.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.jDF.D5vSIB@albercik>
Subject: [Bug #10669] ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (33 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>
		  Ming Lin <ming.m.lin@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16199&amp;action=view


