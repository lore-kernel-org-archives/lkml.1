Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZJKXFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZJKXFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZJKXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:05:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbZJKXFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:05:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stephan von Krawczynski" <skraw@ithnet.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.9UD.zzl0KB@chimera>
Subject: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
Date		: 2009-09-20 11:26 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4


