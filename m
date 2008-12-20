Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYLUA2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYLUA2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYLUA03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:26:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50067 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbYLUA0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:26:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Huemer" <alexander.huemer@sbg.ac.at>,
       "Jarek Poplawski" <jarkao2@gmail.com>
References: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
In-Reply-To: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CMMRhk39O-L.A.tMC.TkYTJB@chimera>
Subject: [Bug #12261] kernel panics with net_rx_action on kernels above 2.6.26
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:16:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12261
Subject		: kernel panics with net_rx_action on kernels above 2.6.26
Submitter	: Alexander Huemer <alexander.huemer@sbg.ac.at>
Date		: 2008-12-13 18:43 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122919424932016&w=4
Handled-By	: Jarek Poplawski <jarkao2@gmail.com>
Patch		: http://marc.info/?l=linux-net&m=122934825227768&w=4


