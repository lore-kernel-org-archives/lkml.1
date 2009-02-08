Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZBHVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZBHVxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZBHVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:48:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZBHVsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:48:43 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ralf Hildebrandt" <ralf.hildebrandt@charite.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.igG.I30jJB@chimera>
Subject: [Bug #12551] end_request: I/O error, dev cciss/c0d0, sector 87435720
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12551
Subject		: end_request: I/O error, dev cciss/c0d0, sector 87435720
Submitter	: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Date		: 2009-01-27 06:51 (13 days old)


