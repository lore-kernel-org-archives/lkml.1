Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbXFKT2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbXFKT2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXFKT2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:28:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:7968 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXFKT2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=At1BAzJ9WIqOCnEeMN+YMTyuXhP2ujWF+SzVL+f3CXHJkT81NVtJlNYA69MXmWmSSXCw32cGmJQBQVPl0+2d3+xg2B31reYzNJlU5Ek2avteVPoYAOiXeJphqvo5MlFi9mF3Ur7LIpf9+N0Wqxp7a52zmiWkh/Jha2x0CY0o4Fc=
Message-ID: <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com>
Date: Mon, 11 Jun 2007 15:28:37 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Albrecht" <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181586424.2436.15.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <200706072323.05576.dtor@insightbb.com>
	 <1181325648.2437.5.camel@albrecht.rdi1.com>
	 <d120d5000706081208q217ca432w6cc6d860a84700e8@mail.gmail.com>
	 <1181582562.6982.5.camel@albrecht.rdi1.com>
	 <d120d5000706111126w59c00bd2p826b7d9f588533ba@mail.gmail.com>
	 <1181586424.2436.15.camel@albrecht.rdi1.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Paul Albrecht <albrecht@rdi1.com> wrote:
> On Mon, 2007-06-11 at 14:26 -0400, Dmitry Torokhov wrote:
> > Hi Paul,
> >
> > On 6/11/07, Paul Albrecht <albrecht@rdi1.com> wrote:
> > >
> > > Resending message from last week ... don't usually subscribe to the
> > > kernel mailing list so please cc me in your response.
> > >
> > > PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> > > PNP: PS/2 controller doesn't have AUX irq; using default 12
> >
> > Does it start working if you boot with i8042.noloop?
> >
>
> No, that doesn't work. Here's the dmesg output:
>

Argh, I meant i8042.noaux. Sorry for the confusion.

-- 
Dmitry
