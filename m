Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbXEGW5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbXEGW5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbXEGW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:57:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbXEGW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:57:43 -0400
Date: Mon, 07 May 2007 15:57:46 -0700 (PDT)
Message-Id: <20070507.155746.63995919.davem@davemloft.net>
To: adaplas@gmail.com
Cc: linux-fbdev-devel@lists.sourceforge.net, hskinnemoen@atmel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: Add support for AVR32
From: David Miller <davem@davemloft.net>
In-Reply-To: <1178578552.4674.33.camel@daplas>
References: <11785512332033-git-send-email-hskinnemoen@atmel.com>
	<20070507.134726.21927689.davem@davemloft.net>
	<1178578552.4674.33.camel@daplas>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Tue, 08 May 2007 06:55:52 +0800

> On Mon, 2007-05-07 at 13:47 -0700, David Miller wrote:
> > From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > Date: Mon,  7 May 2007 17:20:33 +0200
> > 
> 
> > We're at the point where these two snippets of code in the fb layer
> > are a total mess of ifdefs.
> > 
> > It's time we made an include/asm-foo/fb.h header file and abstracted
> > out the necessary details there.
> > 
> 
> I agree. I'll start working on this.
> 
> Tony

Thanks a lot Tony.
