Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZBNX2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZBNX2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbZBNXTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:19:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbZBNXTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:19:40 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@redhat.com>,
       "Philipp Matthias Hahn" <pmhahn@titan.lahn.de>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Yinghai Lu" <yinghai@kernel.org>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.zgH.j40lJB@chimera>
Subject: [Bug #12614] WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12614
Subject		: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Submitter	: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Date		: 2009-01-29 6:31 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=123321232825316&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Tobias Diedrich <ranma+kernel@tdiedrich.de>
Patch		: http://marc.info/?l=linux-kernel&m=123330459229248&w=4
		  http://marc.info/?l=linux-kernel&m=123411195117835&w=4


