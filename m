Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab0BHAqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:46:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab0BHAql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:46:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Garrett" <mjg@redhat.com>,
       "=?utf-8?q?Toralf=20F=C3=B6rster?=" <toralf.foerster@gmx.de>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.YrH.bY1bLB@chimera>
Subject: [Bug #15100] X11 is black after resume from s2ram if my T400 was previous in docking station before
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15100
Subject		: X11 is black after resume from s2ram if my T400 was previous in docking station before
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2010-01-21 08:56 (18 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/c1c7af60892070e4b82ad63bbfb95ae745056de0


