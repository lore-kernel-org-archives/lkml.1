Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZJKXG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZJKXG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZJKXGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:06:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58197 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZJKXGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "gabriele balducci" <balducci@units.it>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.hHC.ezl0KB@chimera>
Subject: [Bug #14275] kernel>=2.6.31: ahci.c: do not force unconditionally sb600 to 32bit dma any more?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14275
Subject		: kernel>=2.6.31: ahci.c: do not force unconditionally sb600 to 32bit dma any more?
Submitter	: gabriele balducci <balducci@units.it>
Date		: 2009-09-30 15:02 (12 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=14275#c0


