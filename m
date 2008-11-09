Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYKIVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYKIVrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYKIVk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:40:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbYKIVkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:40:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Luciano Rocha" <luciano@eurotux.com>, "Tim Wright" <timw@splhi.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
In-Reply-To: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4B0Eqx89uNG.A.fAC.oZ1FJB@chimera>
Subject: [Bug #11843] usb hdd problems with 2.6.27.2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 20:43:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11843
Subject		: usb hdd problems with 2.6.27.2
Submitter	: Luciano Rocha <luciano@eurotux.com>
Date		: 2008-10-22 16:22 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=122469318102679&w=4


