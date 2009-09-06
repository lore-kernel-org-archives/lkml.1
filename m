Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZIFUdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZIFUdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZIFUdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:33:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398AbZIFU2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:28:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.5cD.2fBpKB@chimera>
Subject: [Bug #13942] Troubles with AoE and uninitialized object
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
Subject		: Troubles with AoE and uninitialized object
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-04 10:12 (34 days old)
References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4


