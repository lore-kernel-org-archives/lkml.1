Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbYDMSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbYDMSvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYDMSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:51:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:27946 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYDMSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=K2RMRqAaYKMnr/ujqHaxbHOXzh4Brq/In/AsCZG/MbPzj1Rbv+/Wnau9Vn/0amTI8CiNJv2jC2zSgn9fyv1pGCSKljKqMSlGXzviXByZJPtJVMzuEJeFSOenI9gQXEBkEa60TUsnYSyPpb7W06/QCmoytv9BHv35Le0qABRy9AE=
Message-ID: <ce0170d90804131151ia99147bv9ad12e625191be5e@mail.gmail.com>
Date: Sun, 13 Apr 2008 15:51:13 -0300
From: "Sergio Luis" <sergio@uece.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc8: FTP transfer errors
Cc: "David Miller" <davem@davemloft.net>, w@1wt.eu, johnpol@2ka.mipt.ru,
       lkml@rtr.ca, ilpo.jarvinen@helsinki.fi, jesper.juhl@gmail.com,
       tilman@imap.cc, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <200804132015.21742.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411151821.GA32398@2ka.mipt.ru>
	 <20080412084400.GA30259@1wt.eu>
	 <20080412.024952.151646629.davem@davemloft.net>
	 <200804132015.21742.rjw@sisk.pl>
X-Google-Sender-Auth: b257e0cadcc78248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 12 of April 2008, David Miller wrote:
>  > From: Willy Tarreau <w@1wt.eu>
>  > Date: Sat, 12 Apr 2008 10:44:00 +0200
>  >
>  > > While it is a powerful tool, we must accept that it cannot efficiently
>  > > work in some circumstances, such as :
>  >
>  > Everyone is well aware of all of this, that's why I specifically asked
>  > for a bisect, because I knew it would be crucial to pinpointing this
>  > particular bug.
>  >
>  > And lo' and behold in 15 minutes after the bisect results were
>  > available it got fixed.
>
>  I can't find the fix, btw.  Can you please point me to it?

there you go
http://lkml.org/lkml/2008/4/10/409
http://lkml.org/lkml/2008/4/10/410

>
>  Thanks,
>  Rafael

  -sergio
