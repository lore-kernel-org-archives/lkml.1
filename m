Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZL2PRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZL2PRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZL2POh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:14:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbZL2POf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:14:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Corrado Zoccolo" <czoccolo@gmail.com>,
       "Gui Jianfeng" <guijianfeng@cn.fujitsu.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.1VG.EnhOLB@chimera>
Subject: [Bug #14940] cfq-iosched: tiobench regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14940
Subject		: cfq-iosched: tiobench regression
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2009-12-24 0:55 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=126161612401994&w=4


