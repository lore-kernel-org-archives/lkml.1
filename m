Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZCUTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZCUTv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZCUTrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:47:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbZCUTrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:47:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Lojkin" <ia6432@inbox.ru>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.bvE.Q8TxJB@chimera>
Subject: [Bug #12911] Limiting cpu time doesn't work
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12911
Subject		: Limiting cpu time doesn't work
Submitter	: Peter Lojkin <ia6432@inbox.ru>
Date		: 2009-03-19 18:34 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123749066504641&w=4


