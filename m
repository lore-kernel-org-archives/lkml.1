Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0BUVwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:52:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0BUVwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:52:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alexandre Demers" <papouta@hotmail.com>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "=?utf-8?q?Kristian=20H=C3=B8gsberg?=" <krh@bitplanet.net>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
In-Reply-To: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ClJsQB_ZlxO.A.UYG.YdagLB@chimera>
Subject: [Bug #15259] Corruption with OpenGL since Intel's big DRM push on i945
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:30:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15259
Subject		: Corruption with OpenGL since Intel's big DRM push on i945
Submitter	: Alexandre Demers <papouta@hotmail.com>
Date		: 2010-02-08 13:19 (14 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/76446cac68568fc7f5168a27deaf803ed22a4360


