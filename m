Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYKBSEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYKBSEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYKBSBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:01:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbYKBSBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:01:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fenghua Yu" <fenghua.yu@intel.com>, "Matt Mackall" <mpm@selenic.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.N8G.wkeDJB@chimera>
Subject: [Bug #11847] 2.6.28-rc1 fails building on allnoconfig
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11847
Subject		: 2.6.28-rc1 fails building on allnoconfig
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2008-10-24 17:09 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122487097728241&w=4
		  http://marc.info/?l=linux-pci&m=122485633732409&w=4
Handled-By	: Fenghua Yu <fenghua.yu@intel.com>
Patch		: http://marc.info/?l=linux-kernel&m=122487160129531&w=4


