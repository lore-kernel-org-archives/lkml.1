Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbZDFV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbZDFV4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZDFVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:51:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49924 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759865AbZDFVvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:51:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Daniel Vetter" <daniel@ffwll.ch>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.PxH.FGn2JB@chimera>
Subject: [Bug #12961] Kernel panics in early boot: IO-APIC + timer doesn't work
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12961
Subject		: Kernel panics in early boot: IO-APIC + timer doesn't work
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2009-03-28 19:00 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d6f0c8214928f7c5083dd54ecb69c5d615b516e


