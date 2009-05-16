Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZEPWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZEPWWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZEPWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:15:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43888 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553AbZEPWPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:15:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.1x.sYzDKB@chimera>
Subject: [Bug #13296] Lockdep violation at cleanup_workqueue_thread during suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13296
Subject		: Lockdep violation at cleanup_workqueue_thread during suspend
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2009-05-12 7:59 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124211522525625&w=4


