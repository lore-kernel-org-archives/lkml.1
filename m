Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZKPW7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZKPW7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZKPWxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:53:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbZKPWxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Miles Lane" <miles.lane@gmail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.KFH.STdALB@chimera>
Subject: [Bug #14480] 2 locks held by cat -- running "find /sys | head -c 4" --> system hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14480
Subject		: 2 locks held by cat -- running "find /sys | head -c 4" --> system hang
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-20 16:11 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=125605511728088&w=4
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: http://patchwork.kernel.org/patch/54974/


