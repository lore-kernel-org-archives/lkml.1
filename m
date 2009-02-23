Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZBXAZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZBXAZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZBXAUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:20:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbZBXAUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:20:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alessandro Bono" <alessandro.bono@gmail.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.7IE.QpzoJB@chimera>
Subject: [Bug #12670] BUG: unable to handle kernel paging request at pin_to_kill+0x21
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:10 +0100 (CET)
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
Date		: 2009-02-08 11:04 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


