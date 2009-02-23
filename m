Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbZBXAlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbZBXAlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZBXAfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:35:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502AbZBXAfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:35:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@redhat.com>,
       "Philipp Matthias Hahn" <pmhahn@titan.lahn.de>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Yinghai Lu" <yinghai@kernel.org>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
In-Reply-To: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LLno3yT_fnC.A._5G.LzzoJB@chimera>
Subject: [Bug #12614] WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 23:03:04 +0100 (CET)
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
Date		: 2009-01-29 6:31 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=123321232825316&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Tobias Diedrich <ranma+kernel@tdiedrich.de>
Patch		: http://marc.info/?l=linux-kernel&m=123330459229248&w=4
		  http://marc.info/?l=linux-kernel&m=123411195117835&w=4


