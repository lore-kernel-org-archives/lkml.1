Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757462AbYLQBWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYLQBWk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYLQBW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:22:29 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:31251 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYLQBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wUEESoMC8syr3pGQpQ5jQwiIYZ2XR+/n1jBYvoj771bjSMSmHwRIwctaQ+LrLG02+8
         ugLt8AuQYqX/u2mQCtvIRBH+Of8CgGcCxWxjg9MhjRH+0u4yjjVVLv+TiFxPeBfW9NIc
         ub1q8O/oyl8PPbIY2KBTeUKoEYt0YESH2vaXg=
Subject: Re: Compiling glibc with 2.6.28 linux headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bluebird@gentoo.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20081216.011334.124918024.davem@davemloft.net>
References: <4943DAD6.7070402@gentoo.org>
	 <20081216.011334.124918024.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 17:22:26 -0800
Message-Id: <1229476946.6481.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 01:13 -0800, David Miller wrote:
> From: Friedrich Oslage <bluebird@gentoo.org>
> Date: Sat, 13 Dec 2008 16:55:02 +0100
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Hi,
> > 
> > when compiling glibc(2.9, 20081208 snapshot) with linux 2.6.28-rc8
> > headers I get a lot of errors like this one:
> > 
> > In file included from
> > /tmp/toolchain-build/rootfs/usr/include/asm/byteorder.h:49,
> >                  from
> > /tmp/toolchain-build/rootfs/usr/include/linux/atalk.h:4,
> >                  from ../sysdeps/unix/sysv/linux/netatalk/at.h:25,
> >                  from ../sysdeps/unix/sysv/linux/sa_len.c:22:
> > /tmp/toolchain-build/rootfs/usr/include/linux/byteorder.h:8:3: error:
> > #error Fix asm/byteorder.h to define one endianness
> 
> Harvey, we might need to do something about this.

I'm on the run today, will take a look in 24 hours.

Harvey

