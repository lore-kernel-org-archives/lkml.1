Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZHBVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZHBVzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZHBVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:50:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZHBVuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:50:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "" <kazikcz@gmail.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.aPE.zdgdKB@chimera>
Subject: [Bug #13713] [drm/i915] Possible regression due to commit "Change GEM throttling to be 20ms (...)"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13713
Subject		: [drm/i915] Possible regression due to commit "Change GEM throttling to be 20ms (...)"
Submitter	:  <kazikcz@gmail.com>
Date		: 2009-07-05 10:49 (29 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b962442e46a9340bdbc6711982c59ff0cc2b5afb


