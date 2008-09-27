Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYI0Rrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYI0Rrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYI0Rkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbYI0Rkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.WsG.m7m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11569]=20Don't=20complain=20about=20disabled=20irqs=20when=20the=20system=20has=20paniced?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
Subject		: Don't complain about disabled irqs when the system has paniced
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-09-02 13:49 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4


