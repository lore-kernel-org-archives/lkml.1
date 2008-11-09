Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYKIUHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYKIUHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYKIT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44522 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbYKIT5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.00E.N4zFJB@chimera>
Subject: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:16 +0100 (CET)
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
Date		: 2008-11-03 0:28 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4


