Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZL2PkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZL2PkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZL2PkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:40:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZL2Pe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "okias" <d.okias@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.BpC.qwhOLB@chimera>
Subject: [Bug #14817] When is system under load, then freeze/HD fail
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14817
Subject		: When is system under load, then freeze/HD fail
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-12-15 11:12 (15 days old)


