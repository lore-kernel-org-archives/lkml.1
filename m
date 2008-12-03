Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbYLDAKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbYLDAKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYLDADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:03:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48486 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbYLDAD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:03:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Meelis Roos" <mroos@linux.ee>, "Patrick McHardy" <kaber@trash.net>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.WcH.3oxNJB@chimera>
Subject: [Bug #12153] 2.6.28-rc2: runaway loop modprobe char-major-5-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12153
Subject		: 2.6.28-rc2: runaway loop modprobe char-major-5-1
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-10-28 10:15 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=122518916014197&w=4


