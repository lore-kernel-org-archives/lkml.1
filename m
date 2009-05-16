Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZEPWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZEPWJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbZEPWIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:08:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZEPWIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:08:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Sachin Sant" <sachinp@in.ibm.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.UHD.QazDKB@chimera>
Subject: [Bug #13068] Lockdep warining in inotify_dev_queue_event
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:14:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
Subject		: Lockdep warining in inotify_dev_queue_event
Submitter	: Sachin Sant <sachinp@in.ibm.com>
Date		: 2009-04-05 12:37 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4


