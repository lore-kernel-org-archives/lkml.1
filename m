Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZBHWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZBHWCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBHVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:50:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbZBHVuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:50:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sami Farin" <safari-kernel@safari.iki.fi>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.jpD.H20jJB@chimera>
Subject: [Bug #12669] 2.6.28.4 regression: mmap fails if mlockall used
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12669
Subject		: 2.6.28.4 regression: mmap fails if mlockall used
Submitter	: Sami Farin <safari-kernel@safari.iki.fi>
Date		: 2009-02-08 10:52 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123409037423068&w=4


