Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZL2Pek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZL2Pek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZL2Peg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:34:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZL2Pee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fruhwirth Clemens" <clemens@endorphin.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.elC.dwhOLB@chimera>
Subject: [Bug #14841] unable to enumerate USB device on port X after suspend/resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14841
Subject		: unable to enumerate USB device on port X after suspend/resume
Submitter	: Fruhwirth Clemens <clemens@endorphin.org>
Date		: 2009-12-19 11:45 (11 days old)


