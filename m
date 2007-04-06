Return-Path: <linux-kernel-owner+w=401wt.eu-S1767626AbXDFNYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767626AbXDFNYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767629AbXDFNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:24:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:7744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767626AbXDFNYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rg2JyMfS8/3eyiu/gbuVDaBDsXuJoI+8PYEhRtU8nGJQ1BspbBrk5VEB7bif7BGKcCLKKvus4TJ4UqT9n44pCF/PrpbybGZ0C7AKmpDt1J7M3NWGhXXnoIpYXfQRAyujf0HtpqAlZfy5zsZ6fie4VepYZJnlA0AxUhM/0I8S/j0=
Message-ID: <40f323d00704060624x235063fi7db155db6f3ae55b@mail.gmail.com>
Date: Fri, 6 Apr 2007 15:24:03 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "=?ISO-8859-1?Q?Pedro_Mullor_Jim=E9nez?=" <pmullor@skynet.be>
Subject: Re: 2.6.9 won't compile
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175855823.16114.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1175855823.16114.12.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, Pedro Mullor Jiménez <pmullor@skynet.be> wrote:
> Dear all,
>
> I downloaded version 2.6.9 of the kernel from kernel.org
> I went throught menuconfig, importing the configuration of my current
> 2.6.15-28-686.
>
> I then tried to compile it but the compilation exits with an error
> (below).
>
> I also tried to do make mrproper, got rid of the .config file, made
> menuconfig again without importing anything, and when compiling it
> failed again.
>
> The reason for me to use this kernel is because I have a VIA VT82C
> 693A/598/686 chipset and I suffer from perf problems (which google says
> only happen since 2.6.10).
>
> Might I request to be personally CC'ed in the answers/comments posted in
> response to this post ?
>
I don't think 2.6.9 was gcc-4.x compatible, what version of gcc are you using ?

regards,

Benoit
