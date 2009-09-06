Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZIFUdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZIFUdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbZIFUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:33:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758485AbZIFU2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:28:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Johannes Stezenbach" <js@sig21.net>,
       "Nick Kossifidis" <mickflemm@gmail.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.2ED.vfBpKB@chimera>
Subject: [Bug #13948] ath5k broken after suspend-to-ram
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
Subject		: ath5k broken after suspend-to-ram
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 21:51 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: http://patchwork.kernel.org/patch/38550/


