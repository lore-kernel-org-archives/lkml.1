Return-Path: <linux-kernel-owner+w=401wt.eu-S966172AbXDCOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966172AbXDCOmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966182AbXDCOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:42:39 -0400
Received: from mx.laposte.net ([81.255.54.16]:52888 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966172AbXDCOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:42:38 -0400
Message-ID: <53190.192.54.193.51.1175611316.squirrel@rousalka.dyndns.org>
Date: Tue, 3 Apr 2007 16:41:56 +0200 (CEST)
Subject: Re: OHCI: USB webcam works, but not on USB Hub
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com
Cc: "Michael Bueker" <m.bueker@berlin.de>
User-Agent: SquirrelMail/1.4.8-4.fc6
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Bueker wrote :

> I'm using a USB Webcam with the gspca driver (from
> http://mxhaard.free.fr/download.html), which has been working fine with the
> latest kernels.

...

> Now, I'm writing to this list because one of the followups to that post
> (http://lists.zerezo.com/spca50x-devs/msg00665.html) states that this is
due
> to a problem with the Linux USB layer:
>> pls file a bug "ohci driver can't handle low+fullspeed devices on the same
>> root hub" to linux usb devel list.

Do the gspca driver authors even intend to merge their module in mainline
anytime soon? This kind of problem if typical of out-of-tree development.

-- 
Nicolas Mailhot

