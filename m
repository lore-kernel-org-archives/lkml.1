Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZKPXQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZKPXQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZKPXQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:16:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbZKPXQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Karol Lewandowski" <karol.k.lewandowski@gmail.com>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.loC.CodALB@chimera>
Subject: [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Date		: 2009-09-15 12:05 (63 days old)
References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4


