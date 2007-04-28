Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXD1Lun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXD1Lun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXD1Lun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:50:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030455AbXD1Lum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:50:42 -0400
Date: Sat, 28 Apr 2007 04:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC
 core.
Message-Id: <20070428045018.ff1260da.akpm@linux-foundation.org>
In-Reply-To: <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net>
References: <20070424100203.GB16473@2ka.mipt.ru>
	<20070425174643.f1fc189d.akpm@linux-foundation.org>
	<50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 `make allmodconfig' has a few issues.

ERROR: "clk_get" [drivers/w1/masters/ds1wm.ko] undefined!
ERROR: "clk_put" [drivers/w1/masters/ds1wm.ko] undefined!
ERROR: "clk_disable" [drivers/w1/masters/ds1wm.ko] undefined!
ERROR: "clk_enable" [drivers/w1/masters/ds1wm.ko] undefined!
ERROR: "clk_get_rate" [drivers/w1/masters/ds1wm.ko] undefined!
