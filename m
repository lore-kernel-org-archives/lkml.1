Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZGGABq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZGGABq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZGFX5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485AbZGFX5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miles Lane" <miles.lane@gmail.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.CuD.K0oUKB@chimera>
Subject: [Bug #13731] Inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13731
Subject		: Inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-07-06 4:22 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124685417325348&w=4


