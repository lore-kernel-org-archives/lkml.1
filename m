Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZKUPSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZKUPSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZKUPSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:18:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbZKUPSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:18:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frederik Deweerdt" <frederik.deweerdt@xprog.eu>,
       "Lars Ericsson" <Lars_Ericsson@telia.com>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
In-Reply-To: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mYW9sxtWd2G.A.X9F.tDACLB@chimera>
Subject: [Bug #14253] Oops in driversbasefirmware_class
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 16:02:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14253
Subject		: Oops in driversbasefirmware_class
Submitter	: Lars Ericsson <Lars_Ericsson@telia.com>
Date		: 2009-09-16 20:44 (67 days old)
References	: http://lkml.org/lkml/2009/9/16/461
Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Patch		: http://patchwork.kernel.org/patch/49914/


