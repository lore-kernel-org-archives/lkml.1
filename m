Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZKUPWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZKUPWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZKUPSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:18:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbZKUPSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:18:52 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Karol Lewandowski" <karol.k.lewandowski@gmail.com>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
In-Reply-To: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mYW9sxtWd2G.A.3sF.jDACLB@chimera>
Subject: [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 16:02:11 +0100 (CET)
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
Date		: 2009-09-15 12:05 (68 days old)
References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4


