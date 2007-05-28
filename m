Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbXE1La7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbXE1La7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXE1Lax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:30:53 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42015 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXE1Law (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:30:52 -0400
Date: Mon, 28 May 2007 13:30:47 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: =?UTF-8?B?5LiB5LiB?= <sns2002@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: An error of compile kernel2.6.22-rc3 for ARM CPU s3c2440
In-Reply-To: <9b9ffe290705280405m5086f2dbldea5961ed2b057ca@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705281326050.8531@twin.jikos.cz>
References: <9b9ffe290705280405m5086f2dbldea5961ed2b057ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, ?? wrote:

> I compiled new kernel2.6.22-rc3 for my s3c2440 platform yesterday, I got 
> follow error message from gcc-compiler.
> >CC      arch/arm/plat-s3c24xx/devs.o
> >linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:410:
> error:'S3C2443_PA_HSMMC' undeclared here (not in a function)
> >linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:411:
> error:'S3C2443_SZ_HSMMC' undeclared here (not in a function)

http://lkml.org/lkml/2007/5/28/75

-- 
Jiri Kosina
