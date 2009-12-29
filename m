Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZL2Pfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZL2Pfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZL2Pf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:35:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39340 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbZL2PfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:35:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
       "Zhiyong Wu" <zwu.kernel@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.ueB.LwhOLB@chimera>
Subject: [Bug #14903] Kernel panic - not syncing: Attempted to kill init!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14903
Subject		: Kernel panic - not syncing: Attempted to kill init!
Submitter	: Zhiyong Wu <zwu.kernel@gmail.com>
Date		: 2009-12-18 4:08 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=126110931124738&w=4
Handled-By	: Américo Wang <xiyou.wangcong@gmail.com>


