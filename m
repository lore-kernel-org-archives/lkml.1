Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYI0Rs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYI0Rs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYI0Rkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbYI0Rks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John Daiker" <daikerjohn@gmail.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.OoG.h7m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11607]=202.6.27-rc6=20=C2=A0Bug=20in=20tty_chars_in_buffer?=
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11607
Subject		: 2.6.27-rc6  Bug in tty_chars_in_buffer
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-15 2:26 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=122144565514490&w=4


