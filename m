Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYI0Rtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYI0Rtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYI0Rky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbYI0Rkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "sangu" <sangu.gnome@gmail.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.rQG.S7m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11643]=20ALSA=20sound/core/pcm_native.c:1947:=20BUG?=20(err=20&gt;=3D=200)?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11643
Subject		: ALSA sound/core/pcm_native.c:1947: BUG? (err &gt;= 0)
Submitter	: sangu <sangu.gnome@gmail.com>
Date		: 2008-09-24 16:51 (4 days old)


