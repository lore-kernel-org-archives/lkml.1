Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXIYPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXIYPF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXIYPFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:05:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:20986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbXIYPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=usN3SlGNigmpKE6d+duLjOKpPZFMlqt//yuomSwfzhTOfFO6qBWeEkIVO5CjR8xc23VPsMIKe40KqhfOqy03dUKrZ+EOucnaY1ppApTWTVvcyoGU4Myb3E+BfO1pzHExULgJrb1rn0ezYhWAheJnfdFcsSUWKrKfQyHaPuPp7Gk=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: s2ram + usb
Date: Tue, 25 Sep 2007 18:05:08 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709251055.21767.mihai.dontu@gmail.com> <Pine.LNX.4.64.0709251222040.22331@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0709251222040.22331@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709251805.08828.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Jiri Kosina wrote:
> (linux-usb-devel added to CC)
> 
> On Tue, 25 Sep 2007, Mihai Don?u wrote:
> 
> > [    1.743528] Restarting tasks ... <3>hub 1-0:1.0: port 5 disabled by hub (EMI?), re-enabling...
> > [    1.743563] usb 1-5: USB disconnect, address 3
> > [    1.782485] usb 1-5: new high speed USB device using ehci_hcd and address 6
> > [    1.785747] done.
> > [    1.831805] usb 1-5: configuration #1 chosen from 1 choice
> > [    1.834418] scsi3 : SCSI emulation for USB Mass Storage devices
> > [    1.834741] usb-storage: device found at 6
> > [    1.834785] usb-storage: waiting for device to settle before scanning
> > [    1.845293] ohci_hcd 0000:00:13.1: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
> 
> Hi Mihai,
> 
> does booting with 'irqpoll' kernel parameter have any effect?

No, 'sorry. I get the same message as above. Strangely, 'irqpoll'
disabled 'alt-sysreq-<cmd>' (noticed this after power up).

-- 
Mihai Donțu
