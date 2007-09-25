Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbXIYKX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbXIYKX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbXIYKXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:23:19 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39848 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXIYKXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:23:18 -0400
Date: Tue, 25 Sep 2007 12:23:12 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: s2ram + usb
In-Reply-To: <200709251055.21767.mihai.dontu@gmail.com>
Message-ID: <Pine.LNX.4.64.0709251222040.22331@twin.jikos.cz>
References: <200709251055.21767.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-usb-devel added to CC)

On Tue, 25 Sep 2007, Mihai Don?u wrote:

> [    1.743528] Restarting tasks ... <3>hub 1-0:1.0: port 5 disabled by hub (EMI?), re-enabling...
> [    1.743563] usb 1-5: USB disconnect, address 3
> [    1.782485] usb 1-5: new high speed USB device using ehci_hcd and address 6
> [    1.785747] done.
> [    1.831805] usb 1-5: configuration #1 chosen from 1 choice
> [    1.834418] scsi3 : SCSI emulation for USB Mass Storage devices
> [    1.834741] usb-storage: device found at 6
> [    1.834785] usb-storage: waiting for device to settle before scanning
> [    1.845293] ohci_hcd 0000:00:13.1: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.

Hi Mihai,

does booting with 'irqpoll' kernel parameter have any effect?

-- 
Jiri Kosina
