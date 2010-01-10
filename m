Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705Ab0AJWrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0AJWrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064Ab0AJWkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:40:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab0AJWkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:40:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Shawn Starr" <shawn.starr@rogers.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.Xp.3NlSLB@chimera>
Subject: [Bug #14859] System timer firing too much without cause
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14859
Subject		: System timer firing too much without cause
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2009-12-21 19:16 (21 days old)


