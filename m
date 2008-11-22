Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYKVW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYKVW24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYKVW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:28:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbYKVW2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:28:43 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tejun Heo" <tj@kernel.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.qHE.H9HKJB@chimera>
Subject: [Bug #11858] Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (28 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


