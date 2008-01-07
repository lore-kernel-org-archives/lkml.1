Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYAGR5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYAGR5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYAGR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:57:09 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:6484 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYAGR5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jYr94ChLBqbsUUdkJeK9apmReWu7/bf4xAFiZn9hmaMVhU6fkyLCmgP+3Hy9e32XHEGt7R8jue2fROamy9c1ot7JR2EUD1gJyOxrJe9cCtixvIT7pXWbP7hR767r3iRLgw1MWkpB6LXTlxQ7+aVpwqAsmU8fuBT0PynRBPr/HXU=
From: Gustavo Guillermo =?iso-8859-1?q?P=E9rez?= <madgus@gmail.com>
Organization: www.compunauta.com
To: Marek Kierdelewicz <marek@piasta.pl>
Subject: Re: Corrupted Hard Drive after activating intel I/oat dma
Date: Mon, 7 Jan 2008 11:57:04 -0600
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200712271949.02116.gustavo@compunauta.com> <20071228040345.67db1361@catlap>
In-Reply-To: <20071228040345.67db1361@catlap>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801071157.04573.madgus@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Jueves, 27 de Diciembre de 2007, Marek Kierdelewicz escribió:
> Hi Gustavo,
>
> >By mistake we activate intel I/oat dma support on a laptop with a
> >centrino duo to try to get better performance on IO.
>
> I/OAT is for accelerating network operations on newer Xeon processors
> and E1000 nics. Some information about it is available here:
> http://lwn.net/Articles/165131/
>
> There's no way that enabling this option could cause your hdd to fry.
Thanks to all for the information.
I know, that I'm not having the hardware, but some Intel mother boards sucks 
some times.

> >know the option was not supported, but I want to know if cause that we
> >can have a fried hd :(.
> >thanks in advance if someone has something to said about the
> >failure. :(
> >Kernel 2.6.19-gentoo-r7
>
> I'm a gentoo@laptop user myself. This distro is very disk-demanding
> because of the frequent compilations. In my opinion it's not the best
> distro for a mobile system. No wonder your disk gave out :(.
Well, look, I use to build the system, then my customers and friends use a 
clone of that, so ..., they never compile anything, you should not think like 
that.

> Cheers,
> Marek Kierdelewicz
> KoBa ISP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gustavo Guillermo Pérez
Compunauta uLinux
www.compunauta.com
