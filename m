Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYKPSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYKPSeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYKPSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYKPSd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:33:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Snook" <csnook@redhat.com>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Scott Wood" <scottwood@freescale.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.WdH.LCGIJB@chimera>
Subject: [Bug #11849] default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4


