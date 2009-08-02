Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZHBVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZHBVvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZHBVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:51:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbZHBVvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:51:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.63B.scgdKB@chimera>
Subject: [Bug #13891] PCI resources allocation problem on HP nx6325
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13891
Subject		: PCI resources allocation problem on HP nx6325
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2009-08-02 13:37 (1 days old)
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
Patch		: http://patchwork.kernel.org/patch/38774/


