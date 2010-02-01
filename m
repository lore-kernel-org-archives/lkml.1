Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0BAAhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:37:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0BAAhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:37:17 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Soeren Sonnenburg" <sonne@debian.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
In-Reply-To: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <d3IDKWHT5gE.A.-nC.G8hZLB@chimera>
Subject: [Bug #15043] Display goes off with i915.powersave=1 after suspend-resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:22:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15043
Subject		: Display goes off with i915.powersave=1 after suspend-resume
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2010-01-10 20:09 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126315457519505&w=4


