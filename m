Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZF2AUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZF2AUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZF2ART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:17:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920AbZF2ARQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:17:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "maximilian attems" <max@stro.at>, "Tejun Heo" <tj@kernel.org>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
In-Reply-To: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6JJ2m5kyucK.A.KTC.3IASKB@chimera>
Subject: [Bug #13662] broken alpha smp build
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:11:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13662
Subject		: broken alpha smp build
Submitter	: maximilian attems <max@stro.at>
Date		: 2009-06-25 11:08 (4 days old)
References	: http://lkml.org/lkml/2009/6/25/108
Handled-By	: Tejun Heo <tj@kernel.org>
Patch		: http://patchwork.kernel.org/patch/32714/


