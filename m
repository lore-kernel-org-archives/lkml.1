Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899Ab0AXWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0AXWhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740Ab0AXWhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:37:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0AXWhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:37:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Mike Cui" <cuicui@gmail.com>,
       "Robert Hancock" <hancockrwd@gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.aX.kZMXLB@chimera>
Subject: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata controller
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14922
Subject		: 2.6.32 seemed to have broken nVidia MCP7A sata controller
Submitter	: Mike Cui <cuicui@gmail.com>
Date		: 2009-12-19 6:13 (37 days old)
References	: http://marc.info/?l=linux-ide&m=126120323407742&w=4
Handled-By	: Jeff Garzik <jeff@garzik.org>
		  Robert Hancock <hancockrwd@gmail.com>


