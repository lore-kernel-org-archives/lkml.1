Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZJKXLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZJKXLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZJKXKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:10:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbZJKXE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:04:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Paris" <eparis@parisplace.org>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.KaE.u0l0KB@chimera>
Subject: [Bug #14058] Oops in fsnotify
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


