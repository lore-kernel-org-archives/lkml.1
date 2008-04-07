Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYDGAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYDGAIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYDGAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:08:09 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:16111 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYDGAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ailJX9MCJvpjNZoYYBUMhssGtCg7xfbCmFTTFBRyoBuTYJRb1S8N4SjgzmLDxz5pbuZWFVbvhRrtamuvF7+P4pBIS+pDzPlH57hEcDtNSgizF+bK7Vnoq5pmQ/cB8Jntl8ixIJ0u95QWaIh7c5DrTNp5uux0eQf8fmatKzWsq48=
Message-ID: <dd18b0c30804061708h3fcf27b2t7411ff4f2244a48b@mail.gmail.com>
Date: Mon, 7 Apr 2008 00:08:04 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: suspend issue
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080406232849.GA789@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I don't know how to do a git bisect(too much of a noob)
regards;
               Justin P. Mattock

On Sun, Apr 6, 2008 at 11:28 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
>  > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
>  > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
>  > > I recompile the kernel and had forgotten to compile fglrx, when
>  > > performing a suspend without fglrx I was confronted with the dreaded
>  > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
>  > > and to my amazement suspend reacted properly again.
>  >
>  > Yeah, but I it does not even work without X - console only!
>  >
>  > s2ram -f -p used to work since at least 2.6.20 ... and is now not
>  > anymore in 2.6.25-*
>
>  Can you do git bisect?
>                                                                         Pavel
>  --
>  (english) http://www.livejournal.com/~pavelmachek
>  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Justin P. Mattock
