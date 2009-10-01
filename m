Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZJAXLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZJAXLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbZJAXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:11:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbZJAXLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:11:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "David Miller" <davem@davemloft.net>,
       "Santiago Garcia Mantinan" <manty@manty.net>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.ekH.uMTxKB@chimera>
Subject: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14294
Subject		: kernel BUG at drivers/ide/ide-disk.c:187
Submitter	: Santiago Garcia Mantinan <manty@manty.net>
Date		: 2009-09-30 11:05 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125430926311466&w=4
Handled-By	: David Miller <davem@davemloft.net>


