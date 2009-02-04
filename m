Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZBDM5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZBDM5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZBDMuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbZBDMt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?=" <ozan@pardus.org.tr>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.ZNG.cvYiJB@chimera>
Subject: [Bug #12506] Undefined symbols when CONFIG_MFD_PCF50633 is enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12506
Subject		: Undefined symbols when CONFIG_MFD_PCF50633 is enabled
Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
Date		: 2009-01-17 10:56 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=123218991104592&w=4


