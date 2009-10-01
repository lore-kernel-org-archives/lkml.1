Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZJAXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZJAXPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZJAXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:10:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZJAXJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:09:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heinz Diehl" <htd@fancy-poultry.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.f1._MTxKB@chimera>
Subject: [Bug #14255] WARNING: at drivers/char/tty_io.c:1267
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14255
Subject		: WARNING: at drivers/char/tty_io.c:1267
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2009-09-20 11:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125344629506309&w=4
		  http://lkml.org/lkml/2009/9/8/393
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>


