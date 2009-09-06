Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZIFU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZIFU3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZIFU3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:29:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48829 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbZIFU3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:29:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.RWB.7eBpKB@chimera>
Subject: [Bug #14141] order 2 page allocation failures
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
Subject		: order 2 page allocation failures
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-09-06 7:40 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


