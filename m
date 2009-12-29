Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZL2Pnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZL2Pnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZL2Pd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:33:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZL2PdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:33:24 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Teoh" <htmldeveloper@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.ipD.hxhOLB@chimera>
Subject: [Bug #14655] swapper generated call trace in 2.6.32-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14655
Subject		: swapper generated call trace in 2.6.32-rc7
Submitter	: Peter Teoh <htmldeveloper@gmail.com>
Date		: 2009-11-18 8:09 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=125853179413679&w=4


