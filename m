Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZCUTVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZCUTVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZCUTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:18:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbZCUTSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:18:49 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alessandro Bono" <alessandro.bono@gmail.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.T8B.vaTxJB@chimera>
Subject: [Bug #12670] BUG: unable to handle kernel paging request at pin_to_kill+0x21
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12670
Subject		: BUG: unable to handle kernel paging request at pin_to_kill+0x21
Submitter	: Alessandro Bono <alessandro.bono@gmail.com>
Date		: 2009-02-08 11:04 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


