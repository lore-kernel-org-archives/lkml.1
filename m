Return-Path: <linux-kernel-owner+w=401wt.eu-S936364AbXGUJwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936364AbXGUJwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbXGUJwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:52:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56692 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbXGUJwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:52:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A1D752.6070101@s5r6.in-berlin.de>
Date: Sat, 21 Jul 2007 11:52:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: CONFIG_VIRT_TO_BUS: what about bus_to_virt?
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it sensible and safe to let a driver which uses bus_to_virt (but not
virt_to_bus) depend on CONFIG_VIRT_TO_BUS?  Thanks,
-- 
Stefan Richter
-=====-=-=== -=== =-=-=
http://arcgraph.de/sr/
