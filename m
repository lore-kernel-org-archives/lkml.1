Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZAKOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZAKOBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbZAKN6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:58:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZAKN6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:58:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Caleb Cushing" <xenoterracide@gmail.com>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.ncC.2afaJB@chimera>
Subject: [Bug #12264] i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12264
Subject		: i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Submitter	: Caleb Cushing <xenoterracide@gmail.com>
Date		: 2008-12-16 11:40 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=122942777030666&w=4


