Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXJZJRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXJZJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbXJZJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:17:23 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:4081 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXJZJRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ml/ChqMNnoqsxHMcogXO67uZwTLnnPzw+wc35xQO75o3IfsM6s3BpvHuY39WzHZfJ1W120YJPty/q0uhosj3pLFfoJSWloqp1BTHxHqnwSGOsLkwE7EbX+rrv2YIa2JNFFJgb8OZurGnjV89YjAzOTGxl6Uuco3L4zGgzzYANSQ=
Message-ID: <fceeb6990710260217g6892c6d9vb31b2fbaff42000@mail.gmail.com>
Date: Fri, 26 Oct 2007 11:17:21 +0200
From: "Piero Ottuzzi" <lkmltimes@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: Upcomming CRIS patches
Cc: linux-kernel@vger.kernel.org, "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       "Mikael Starvik" <mikael.starvik@axis.com>
In-Reply-To: <fceeb6990710260204o5ecab9abm944be41ee57acd6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BFECAF9E178F144FAEF2BF4CE739C6680547FAFA@exmail1.se.axis.com>
	 <BFECAF9E178F144FAEF2BF4CE739C66804C4011D@exmail1.se.axis.com>
	 <fceeb6990710260204o5ecab9abm944be41ee57acd6c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/26, Piero Ottuzzi <lkmltimes@gmail.com>:
> 2007/10/26, Mikael Starvik <mikael.starvik@axis.com>:
> > >Are there access to a cross-compile chain for i386 somewhere?
> >
> > Sure, that's the only way we do it (CRIS has typically too low performance
> > and memory to compile anything although it has been shown that it is
> > possible)
> >
> > You can find the compiler at
> > http://www.axis.com/reg/login.php?oldurl=/products/dev_sdk/download_compiler
> > .php.
> > Unfortunately you have to register.
> >
>
> Hi there,
>
> you can download the compiler without registration at [1].
>
> Bye
> Piero
> [1]http://www.axis.com/ftp/pub/axis/tools/cris/compiler-kit/
>

Or via ftp [ftp://ftp.axis.com/pub/axis/tools/cris/compiler-kit/] if you prefer.

Bye
Piero

-- 
LKML Times: The Linux Kernel Mailing List newspaper
http://lkmltimes.brucalipto.org/
