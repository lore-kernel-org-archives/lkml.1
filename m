Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0BUVxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:53:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0BUVxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:53:17 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Pedro Ribeiro" <pedrib@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
In-Reply-To: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ClJsQB_ZlxO.A.C4E.PcagLB@chimera>
Subject: [Bug #15367] i915: resume from hibernate locks up every 2nd time
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:30:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15367
Subject		: i915: resume from hibernate locks up every 2nd time
Submitter	: Pedro Ribeiro <pedrib@gmail.com>
Date		: 2010-02-17 18:47 (5 days old)
Message-ID	: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126643245012840&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://patchwork.kernel.org/patch/80456/


