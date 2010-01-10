Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502Ab0AJWmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0AJWmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434Ab0AJWmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:42:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0AJWmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:42:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "James Simmons" <jsimmons@infradead.org>,
       "Johan Hovold" <jhovold@gmail.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.C_F.wMlSLB@chimera>
Subject: [Bug #15038] drm/ksm: fbdev blanking regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15038
Subject		: drm/ksm: fbdev blanking regression
Submitter	: Johan Hovold <jhovold@gmail.com>
Date		: 2010-01-06 17:00 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
References	: http://marc.info/?l=linux-kernel&m=126279726418748&w=4
Handled-By	: James Simmons <jsimmons@infradead.org>


