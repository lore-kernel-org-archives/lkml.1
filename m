Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYKIT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYKIT6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYKIT4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:56:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44394 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbYKIT4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:56:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Avi Kivity" <avi@redhat.com>,
       "Ingo Molnar" <mingo@elte.hu>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.5I.V5zFJB@chimera>
Subject: [Bug #11895] 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11895
Subject		: 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:05 (13 days old)
References	: http://marc.info/?l=linux-acpi&m=122522085418555&w=4
Handled-By	: Andrey Borzenkov <arvidjaar@mail.ru>
Patch		: http://marc.info/?l=linux-kernel&m=122547719810921&w=4


