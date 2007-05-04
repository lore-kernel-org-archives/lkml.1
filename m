Return-Path: <linux-kernel-owner+w=401wt.eu-S1767486AbXEDAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767486AbXEDAKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767494AbXEDAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:10:21 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:33104 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767486AbXEDAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:10:20 -0400
Date: Thu, 3 May 2007 19:10:17 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: ExpressCard hotswap support?
Message-ID: <20070504001017.GC1213194@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a Thinkpad Z60m with an ExpressCard slot, and I got a Belkin
F5U250 GigE ExpressCard (Marvell 88E8053 chip using sky2 driver).  It
appears that Linux only recognizes it if I insert the card with the
system powered off.  If I hot-insert the card, nothing happens (no
messages logged, no PCI device shows up, nothing).

Does Linux support hotswapping ExpressCards?

This is with Fedora Core 6 with all updates, kernel 2.6.20-1.2948.fc6.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
