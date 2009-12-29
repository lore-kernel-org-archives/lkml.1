Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZL2PQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZL2PQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZL2PP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:15:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZL2PPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:15:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "fengxiangjun" <fengxiangjun@neusoft.com>, "Tejun Heo" <tj@kernel.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.aBG.AnhOLB@chimera>
Subject: [Bug #14944] 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14944
Subject		: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
Submitter	: fengxiangjun <fengxiangjun@neusoft.com>
Date		: 2009-12-21 11:12 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126139442328314&w=4
Handled-By	: Tejun Heo <tj@kernel.org>
Patch		: http://patchwork.kernel.org/patch/69746/


