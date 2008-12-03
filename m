Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYLDALN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYLDALN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbYLDADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:03:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbYLDADd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:03:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Gaudenz Steinlin" <gaudenz@debian.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.8DH.voxNJB@chimera>
Subject: [Bug #12158] commit b1ee26b freezes system on switching from X to text console
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:04 +0100 (CET)
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
Date		: 2008-11-25 19:44 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


