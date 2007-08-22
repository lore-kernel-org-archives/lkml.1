Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbXHVAsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbXHVAsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXHVAsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:48:20 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:37324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXHVAsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LmB38pVgyaBBvUSSqpzU18271KHtR9fcPfY/UKMyU6bZqBwIa2ryGn29UdwerQRhD38pgPJVebhQRHhmp3E4CJMcrT4wDRGIvCcM3PcLhXJQzJnEVmYkm4OickVlRqECCp2e4U2QBa9izO+fVUpeaTyyqgJiBCzFEZCfpHkRgTg=
Message-ID: <9a8748490708211748v4c1aacbak3a44f893d08381ae@mail.gmail.com>
Date: Wed, 22 Aug 2007 02:48:16 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Noud Aldenhoven" <jwaixs@gmail.com>
Subject: Re: How to learn Linux Kernel Programming
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cb63d1e10708211229n18cc154ep43912a671ca1bfee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb63d1e10708211228u383240a2l4af811f72b8858c0@mail.gmail.com>
	 <cb63d1e10708211229n18cc154ep43912a671ca1bfee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/07, Noud Aldenhoven <jwaixs@gmail.com> wrote:
> Hello Kernel Develop mailing list,
>
...
>
> I'm a simple Math/Computer Science student and would like to learn
> more about linux and it's kernel.
> To be more precise, I'd to learn how to program in the linux kernel
> and maybe become a developer,
> if everything goes fine.
> But where do I start?

Start by reading Documentation/HOWTO from a recent copy of the kernel source.


> Almost all information I found on the Internet
> if from before 2005

There's lots of good kernel related material to be found online. See
for example :

http://kernelnewbies.org/
http://janitor.kernelnewbies.org/
http://lwn.net/Kernel/LDD3/
http://lwn.net/Kernel/
http://kerneltrap.org/
http://kerneltraffic.org/


> and I think that
> means it's out-of-date.

That's not always true.


> Are there up-to-date documentations that are
> use full to read and explain how
> the kernel is build. (for example, is /usr/src/linux/Documentation a
> use full dir?)

Yes it is useful.  Not everything in there is 100% up-to-date, but
there is still a *LOT* of useful documentation to be found there.


> An other question I'd like to ask is how and where did you start? I'd
> like to know how you manage to became
> linux kernel developers.
>
Most people start out fixing small bugs, cleanups etc or by
implementing some small feature or driver that they need. There's no
fixed way.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
