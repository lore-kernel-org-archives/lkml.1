Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZKPWwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZKPWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZKPWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:52:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60148 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZKPWvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:51:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A._8.rUdALB@chimera>
Subject: [Bug #14298] warning at manage.c:361 (set_irq_wake), matrix-keypad related?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


