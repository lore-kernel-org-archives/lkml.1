Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYLUAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYLUAOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYLUAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:10:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbYLUAKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:10:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Caleb Cushing" <xenoterracide@gmail.com>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
In-Reply-To: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vy-yJy0f3YP.A.3-H.BaYTJB@chimera>
Subject: [Bug #12264] i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:00:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12264
Subject		: i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Submitter	: Caleb Cushing <xenoterracide@gmail.com>
Date		: 2008-12-16 11:40 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122942777030666&w=4


