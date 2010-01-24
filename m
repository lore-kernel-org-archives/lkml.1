Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543Ab0AXWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0AXWVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509Ab0AXWVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:21:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab0AXWRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:43 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Jeff Garrett" <jeff@jgarrett.org>,
       "Linux PCI" <linux-pci@vger.kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.tpF.EKMXLB@chimera>
Subject: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
Subject		: PCI host bridge windows ignored (works with pci=use_crs)
Submitter	: Jeff Garrett <jeff@jgarrett.org>
Date		: 2010-01-13 5:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>


