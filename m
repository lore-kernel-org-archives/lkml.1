Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbXFLGO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbXFLGO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbXFLGOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:14:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXFLGOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:14:17 -0400
Message-ID: <466E39B4.1040400@zytor.com>
Date: Mon, 11 Jun 2007 23:14:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bruce Ashfield <bruce.ashfield@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can we get rid of zImage this time?
References: <466DE04C.4020303@zytor.com> <3bd6b93c0706111920p36d866a6m18915696fd386473@mail.gmail.com>
In-Reply-To: <3bd6b93c0706111920p36d866a6m18915696fd386473@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Ashfield wrote:
> 
> These beasts are still alive and kicking. I boot a handful of
> arm and ppc boards on a frequent basis that are zImage
> only.  The kicker is I don't have the bootloader source for
> most of them, so changing to a different image format is
> tough at best.
> 

Sorry, the zImage/bzImage distinction is x86 only.  Some other
architectures call their output zImage, but it's a different format
entirely.

So I was referring specifically to x86.

	-hpa
