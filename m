Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZJKXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZJKXGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZJKXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:06:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58185 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZJKXGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Karol Lewandowski" <karol.k.lewandowski@gmail.com>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.YoC.lzl0KB@chimera>
Subject: [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:08 +0200 (CEST)
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
Date		: 2009-09-15 12:05 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4


