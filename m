Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZL2PSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZL2PSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZL2PN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:13:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZL2PNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Ingo Molnar" <mingo@elte.hu>, "Roland Dreier" <rdreier@cisco.com>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.A9H.cnhOLB@chimera>
Subject: [Bug #14901] bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14901
Subject		: bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
Submitter	: Roland Dreier <rdreier@cisco.com>
Date		: 2009-12-15 7:47 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126086324302061&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
		  Yinghai Lu <yinghai@kernel.org>


