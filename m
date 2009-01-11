Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZAKN7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZAKN7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZAKN5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:57:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZAKN5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:57:44 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "netdev" <netdev@vger.kernel.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.xMD.hbfaJB@chimera>
Subject: [Bug #12160] networking oops after resume from s2ram (2.6.28-rc6)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12160
Subject		: networking oops after resume from s2ram (2.6.28-rc6)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-11-28 21:15 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=122790701615723&w=4


