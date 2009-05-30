Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbZE3W7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbZE3W7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbZE3Wy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:54:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761030AbZE3Wy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Richard Atterer" <richard@2009.atterer.net>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.i1F.bVbIKB@chimera>
Subject: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
Subject		: s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
Submitter	: Richard Atterer <richard@2009.atterer.net>
Date		: 2009-05-16 22:51 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
		  http://lkml.org/lkml/2009/5/25/253


