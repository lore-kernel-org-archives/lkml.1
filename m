Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZKPXQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZKPXQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZKPXQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:16:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60560 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbZKPXQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:03 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tsvety Petrov" <Tsvetoslav.Petrov@itron.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.hbD.HpdALB@chimera>
Subject: [Bug #14114] Tuning a saa7134 based card is broken in kernel 2.6.31-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14114
Subject		: Tuning a saa7134 based card is broken in kernel 2.6.31-rc7
Submitter	: Tsvety Petrov <Tsvetoslav.Petrov@itron.com>
Date		: 2009-09-03 21:06 (75 days old)


