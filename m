Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYIUUpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYIUUpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYIUUge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:36:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57187 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYIUUgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:36:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Joshua Hoblitt" <j_kernel@hoblitt.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.zJH.p0q1IB@albercik>
Subject: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
Subject		: kernel panic: softlockup in tick_periodic() ???
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-09-11 16:46 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Ingo Molnar <mingo@elte.hu>


