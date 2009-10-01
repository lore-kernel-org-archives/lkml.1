Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZJAXKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZJAXKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZJAXKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:10:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZJAXJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:09:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.ot.9MTxKB@chimera>
Subject: [Bug #14256] kernel BUG at fs/ext3/super.c:435
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14256
Subject		: kernel BUG at fs/ext3/super.c:435
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-09-21 7:29 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125351816109264&w=4


