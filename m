Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbZCNVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbZCNVxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZCNVoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:44:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475AbZCNVoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:44:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "John W. Linville" <linville@tuxdriver.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.mbC.M4BvJB@chimera>
Subject: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:05:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
Subject		: 2.6.29-rc "TKIP: replay detected" regression
Submitter	: Hugh Dickins <hugh@veritas.com>
Date		: 2009-03-11 12:07 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
Handled-By	: John W. Linville <linville@tuxdriver.com>


