Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556Ab0AXWgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0AXWgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314Ab0AXWgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:36:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0AXWgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:36:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Evgeniy Polyakov" <zbr@ioremap.net>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.ev.vZMXLB@chimera>
Subject: [Bug #14894] pohmelfs: NULL pointer dereference
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
Subject		: pohmelfs: NULL pointer dereference
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-12-02 1:11 (54 days old)
References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>


