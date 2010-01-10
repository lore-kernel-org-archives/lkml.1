Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493Ab0AJWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0AJWmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443Ab0AJWmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:42:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0AJWmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:42:14 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "Daniel Mack" <daniel@caiaq.de>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.f2F.uMlSLB@chimera>
Subject: [Bug #15039] leds_alix2: can't allocate I/O for GPIO
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


