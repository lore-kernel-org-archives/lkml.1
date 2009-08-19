Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZHSXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZHSXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZHSXZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:25:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZHSXZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:25:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matthias Dahl" <ml_kernel@mortal-soul.de>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ADSuNT6McuD.A.a5H.sNIjKB@chimera>
Subject: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:27:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14011
Subject		: Kernel paging request failed in kmem_cache_alloc
Submitter	: Matthias Dahl <ml_kernel@mortal-soul.de>
Date		: 2009-08-10 22:26 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=124993603825082&w=4


