Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0BGWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:45:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab0BGWps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:45:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "Daniel Mack" <daniel@caiaq.de>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.K-B.epzbLB@chimera>
Subject: [Bug #15039] leds_alix2: can't allocate I/O for GPIO
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


