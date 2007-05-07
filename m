Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbXEGW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbXEGW4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXEGW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:56:03 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:56523 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbXEGW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gyX8L2xVn24Yw+fqM9WJST+ana84Kl49EQHQU8VI3R89dx00tl3E5R6qel6M2ahKFx25F3HV64szdcSOSJUdAn3jrSUtaZxeuRDtc7yCnjK2qZYQ7GmUjDi36aZx9T9HXI2WvbYA2OGsDssH4mxlkhHsUpL7hMNlsGds0CfDS+A=
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: Add support for AVR32
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: hskinnemoen@atmel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070507.134726.21927689.davem@davemloft.net>
References: <11785512332033-git-send-email-hskinnemoen@atmel.com>
	 <20070507.134726.21927689.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 08 May 2007 06:55:52 +0800
Message-Id: <1178578552.4674.33.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 13:47 -0700, David Miller wrote:
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Date: Mon,  7 May 2007 17:20:33 +0200
> 

> We're at the point where these two snippets of code in the fb layer
> are a total mess of ifdefs.
> 
> It's time we made an include/asm-foo/fb.h header file and abstracted
> out the necessary details there.
> 

I agree. I'll start working on this.

Tony


