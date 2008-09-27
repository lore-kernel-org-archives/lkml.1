Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYI0Rqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYI0Rqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYI0RkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYI0RkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Zhu Yi" <yi.zhu@intel.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.zoH.e8m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11476]=20failure=20to=20associate=20after=20resume=20from=20suspend=20to=20ram?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


