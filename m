Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbZCCWKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbZCCWKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZCCWBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:01:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbZCCWBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:01:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Rog=C3=A9rio=20Brito?=" <rbrito@ime.usp.br>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.D_.lUarJB@chimera>
Subject: [Bug #12811] undefined reference to `physmap_set_partitions' on powerpc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12811
Subject		: undefined reference to `physmap_set_partitions' on powerpc
Submitter	: Rogério Brito <rbrito@ime.usp.br>
Date		: 2009-03-02 9:43 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123598702511826&w=4
Handled-By	: Rogério Brito <rbrito@ime.usp.br>
Patch		: http://marc.info/?l=linux-kernel&m=123606933628020&w=4


