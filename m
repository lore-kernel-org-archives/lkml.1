Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZCCWC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZCCWC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbZCCV75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:59:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100AbZCCV7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:59:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alessandro Bono" <alessandro.bono@gmail.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.ZDD.cVarJB@chimera>
Subject: [Bug #12670] BUG: unable to handle kernel paging request at pin_to_kill+0x21
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:54 +0100 (CET)
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
Date		: 2009-02-08 11:04 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


