Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYI0Rpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYI0Rpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYI0RkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39053 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYI0RkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jason Vas Dias" <jason.vas.dias@gmail.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.TLH.C8m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11516]=20severe=20performance=20degradation=20on=20x86_64=20going=20from=202.6.26-rc9=
Date: Sat, 27 Sep 2008 17:56:46 +0200 (CEST)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -&gt; 2.6.27-rc5?To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11516
Subject		: severe performance degradation on x86_64 going from 2.6.26-rc9 -&gt; 2.6.27-rc5
Submitter	: Jason Vas Dias <jason.vas.dias@gmail.com>
Date		: 2008-09-07 13:59 (21 days old)


