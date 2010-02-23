Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0BWG24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:28:56 -0500
Received: from snt0-omc1-s37.snt0.hotmail.com ([65.55.90.48]:33678 "EHLO
	snt0-omc1-s37.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab0BWG2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:28:55 -0500
Message-ID: <SNT125-W2213C38FBE28FE6BEEC54CC3420@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: RE: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Mon, 22 Feb 2010 22:28:54 -0800
Importance: Normal
In-Reply-To: <4B7CAF95.6020306@gmail.com>
References: <4B7CAF95.6020306@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Feb 2010 06:28:54.0536 (UTC) FILETIME=[78CA6080:01CAB451]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Add a module parameter to allow the user to enable 64-bit DMA support in EHCI,
> which has been forcibly disabled since 2003 - see:
>
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg17230.html
>
> At that time the comment was "it'd only matter on a few big Intel boxes anyway",

That months *after* AMD released the Opteron and Athlon 64 processors with x86_64 support, with an x86_64 version of Linux.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
http://clk.atdmt.com/GBL/go/201469229/direct/01/