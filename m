Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXGFQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXGFQVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXGFQVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:21:11 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:39262 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbXGFQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:21:10 -0400
Message-Id: <200707061621.l66GL8Fr015353@dell2.home>
To: linux-kernel@vger.kernel.org
cc: martin.leisner@xerox.com
Subject: working sata_vsc driver with 2.6.20?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15350.1183738867.1@dell2.home>
Date: Fri, 06 Jul 2007 12:21:08 -0400
From: "Marty Leisner" <leisner@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a hell of a time with the sata_vsc driver with 2.6.20...

2.6.21 works fine --but the driver is radically different -- is there
a method to build the 2.6.21 driver against 2.6.20?

There are a number of patches on the 2.6.20 sata driver
(it works on a PC platform, but fails with our embedded ppc board).
It seems there was a regression loss from 2.6.19 to 2.6.20 -- but I can't
easily build the 2.6.19 driver against 2.6.20...

Where is the definitive 2.6.20 sata_vsc driver?

marty
