Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0BWGsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:48:39 -0500
Received: from snt0-omc1-s16.snt0.hotmail.com ([65.55.90.27]:6364 "EHLO
	snt0-omc1-s16.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab0BWGsh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:48:37 -0500
Message-ID: <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hancockrwd@gmail.com>, <david-b@pacbell.net>
CC: <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: RE: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Mon, 22 Feb 2010 22:48:37 -0800
Importance: Normal
In-Reply-To: <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>
  <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
  <201002192139.46189.david-b@pacbell.net>,<51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Feb 2010 06:48:37.0262 (UTC) FILETIME=[39C00AE0:01CAB454]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> According to one Microsoft page I saw, Windows XP did not implement
> the 64-bit addressing feature in EHCI. I haven't found any information
> on whether any newer Windows versions do or not.
Windows 7 seems to support it, and it seems like they have to already do a workaround for broken NVIDIA chipsets:
http://support.microsoft.com/?kbid=976972
http://www.windows7tipsonline.com/USB_Problem.htm
http://social.technet.microsoft.com/Forums/en-US/w7itprohardware/thread/3aae3b66-6a1a-47e8-ad1b-b20b68eaecf8#79ea3219-d76e-40bc-b910-c7d347002e66
http://social.technet.microsoft.com/Forums/en-US/w7itprohardware/thread/38f25c1d-de67-4c74-8845-2cd3a15d8e41

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/201469230/direct/01/