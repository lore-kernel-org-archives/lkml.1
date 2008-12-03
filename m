Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYLDANA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYLDANA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYLDAEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:04:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876AbYLDAE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:04:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Wim Van Sebroeck" <wim@iguana.be>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.bmG.moxNJB@chimera>
Subject: [Bug #12162] Commit 7cd5b08be3 breaks startup on Toshiba Portege R500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12162
Subject		: Commit 7cd5b08be3 breaks startup on Toshiba Portege R500
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-12-03 22:00 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7cd5b08be3c489df11b559fef210b81133764ad4
References	: http://marc.info/?l=linux-kernel&m=122834170321535&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
Patch		: http://marc.info/?l=linux-kernel&m=122834271623218&w=4


