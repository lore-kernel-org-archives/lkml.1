Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXFOO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXFOO6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXFOO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:58:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:33537 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbXFOO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gKekOxGl3mvXDZQD2dghsqyhMCCBGbM8mjJCBB2LYYV0mwh1n+OoBPuJFtyrq6PbT6ofc/SOSeWyOkyaoygbHPUh/p405VjscLNRA/z1OrCEuu/xQEmAWAFGsW2DmOIWUt59O5WRJefk1XITgbwFZ+cCYtuoPQ/RY4ayW1NUzqc=
Message-ID: <9a8748490706150758s51f787ccy4acbdec9fa356b8a@mail.gmail.com>
Date: Fri, 15 Jun 2007 16:58:27 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Bernd Paysan" <bernd.paysan@gmx.de>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000706150752n72668be2qf5b56b43cb253174@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <200706151014.45383.bernd.paysan@gmx.de>
	 <46727CCF.9030905@grupopie.com>
	 <200706151403.57178.bernd.paysan@gmx.de>
	 <4672A231.9000800@grupopie.com>
	 <20070615154522.2a161884@the-village.bc.nu>
	 <d120d5000706150752n72668be2qf5b56b43cb253174@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 6/15/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > But COPYING *is* the entire text and starts with: "
> > >                   GNU GENERAL PUBLIC LICENSE
> > >                      Version 2, June 1991"
> > >
> > > so there is no confusion about the version.
> >
> > The version of the COPYING file (and the licence document), not of the
> > licence on the code.
> >
>
> Using this logic one can say that Linux kernel is BSD or even public
> domain and COPYING is there just for kicks.
>
No. Only the original author can specify the license. If no license at
all is specified only the author has any rights to the work, other
people don't have any right to distribute, modify or whatever.
So if the COPYING file doesn't specify the license for work without a
license clause directly in the file, then only the author has any
rights, you can't just then move in and assign an arbitrary license.
But I think you would find it very hard to argue that files
contributed to the Linux kernel without an explicit license notice
does not fall under the terms set forth in the COPYING document.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
