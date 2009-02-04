Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZBDM5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZBDM5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZBDMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZBDMt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dan Williams" <dan.j.williams@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.dvF.SvYiJB@chimera>
Subject: [Bug #12511] WARNING: at drivers/dma/dmaengine.c:352
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12511
Subject		: WARNING: at drivers/dma/dmaengine.c:352
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-01-19 21:31 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=123240070614443&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


