Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYGMTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYGMTUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYGMTSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbYGMTSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin Mattock" <justinmattock@gmail.com>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.si.HIleIB@albercik>
Subject: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10954
Subject		: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-06-21 2:05 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121401399622190&w=4
		  http://marc.info/?t=121416231700010&r=1&w=4


