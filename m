Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYKPSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYKPSmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYKPSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbYKPSfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.g7E.mAGIJB@chimera>
Subject: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11989
Subject		: Suspend failure on NForce4-based boards due to chanes in stop_machine
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-11-03 0:28 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://lkml.org/lkml/2008/11/15/69


