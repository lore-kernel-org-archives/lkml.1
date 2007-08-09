Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbXHIL4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbXHIL4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937323AbXHIL4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:56:21 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:9145 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765621AbXHIL4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:56:20 -0400
X-ME-UUID: 20070809115618526.808FC1C0008A@mwinf2711.orange.fr
Subject: Re: linux USB Device.
From: Xavier Bestel <xavier.bestel@free.fr>
To: jonatan perry <jonatan44@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d592e5da0708082039i739c8045o12c953d7dd7778cb@mail.gmail.com>
References: <d592e5da0708082039i739c8045o12c953d7dd7778cb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 13:56:14 +0200
Message-Id: <1186660574.13723.164.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 06:39 +0300, jonatan perry wrote:
> Hello,
> I would like to know who the USB system works under linux, I mean,
> I would like to write a kernel module who will create a virtual USB
> device, so that the kernel will think that a hardware USB device is
> exists, were can I start?

Look at the "usb gadgets" subsystem.

	Xav


