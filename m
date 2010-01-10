Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942Ab0AJXEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0AJXEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311Ab0AJXEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:04:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab0AJXEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:04:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Thomas Meyer" <thomas@m3y3r.de>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.GGD.GilSLB@chimera>
Subject: [Bug #14670] i915: playing video via XVideo extension makes the screen flicker
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
Subject		: i915: playing video via XVideo extension makes the screen flicker
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-11-23 13:15 (49 days old)


