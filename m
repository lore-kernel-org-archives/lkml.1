Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZJAXHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZJAXHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZJAXHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:07:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZJAXHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:07:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.whD.jPTxKB@chimera>
Subject: [Bug #13733] 2.6.31-rc2: irq 16: nobody cared
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:55:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (88 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


