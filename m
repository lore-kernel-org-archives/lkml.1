Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYLGWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYLGWnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYLGWjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:39:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYLGWjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:39:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Gaudenz Steinlin" <gaudenz@debian.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
In-Reply-To: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <07Xes05z25M.A.OcF.csEPJB@chimera>
Subject: [Bug #12158] commit b1ee26b freezes system on switching from X to text console
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:32:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12158
Subject		: commit b1ee26b freezes system on switching from X to text console
Submitter	: Gaudenz Steinlin <gaudenz@debian.org>
Date		: 2008-11-25 19:44 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


