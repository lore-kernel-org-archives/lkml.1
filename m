Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0BNX6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:58:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0BNX5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:57:52 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Galbraith" <efault@gmx.de>,
       "Mike Galbraith" <efault@gmx.de>, "Roman Mamedov" <roman@rm.pp.ru>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.zP.CkIeLB@chimera>
Subject: [Bug #15044] Much higher wakeups for "<kernel IPI> : Rescheduling interrupts" since 2.6.32.2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:38:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15044
Subject		: Much higher wakeups for "<kernel IPI> : Rescheduling interrupts" since 2.6.32.2
Submitter	: Roman Mamedov <roman@rm.pp.ru>
Date		: 2010-01-11 02:58 (35 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/a1f84a3ab8e002159498814eaa7e48c33752b04b


