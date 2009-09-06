Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZIFUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZIFUR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbZIFUR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:17:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZIFURx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:17:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "poornima nayak" <mpnayak@linux.vnet.ibm.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.RPE.hhBpKB@chimera>
Subject: [Bug #13645] NULL pointer dereference at (null) (level2_spare_pgt)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:15:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (82 days old)
References	: http://lkml.org/lkml/2009/6/17/194


