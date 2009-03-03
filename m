Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZCCWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZCCWFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZCCWA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39370 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604AbZCCWA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Brian Haley" <brian.haley@hp.com>,
       "=?utf-8?q?J.A.=20Magall=C3=B3n?=" <jamagallon@ono.com>,
       "Jay Vosburgh" <fubar@us.ibm.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.sfC.GVarJB@chimera>
Subject: [Bug #12761] Bonding tied to IPV6 in 29-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12761
Subject		: Bonding tied to IPV6 in 29-rc5
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2009-02-17 8:52 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=123486078219980&w=4
Handled-By	: Brian Haley <brian.haley@hp.com>
Patch		: http://marc.info/?l=linux-kernel&m=123517631120945&w=4


