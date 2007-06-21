Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbXFUTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbXFUTdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXFUTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:33:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:44939 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbXFUTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AaLY86xDKfQJ89H2KgebI8gqN3v+t2nRTarM6uPfCr2Yba3LW5SkehhPf6cXwb3T7kJlGtEBH69ID6kfX8CuwXTWflBd7Ts4kL8AX4SFUIQNaZCIIH8M6X+f8b5IhTpPSyGeKzYVSRTsNqTXj+aiFk5y+mngUtF816p1WxD1Br4=
Message-ID: <68676e00706211233l7fa22ef6m891e61b831de2f02@mail.gmail.com>
Date: Thu, 21 Jun 2007 21:33:02 +0200
From: Luca <kronos.it@gmail.com>
To: "Rudolf Marek" <r.marek@assembler.cz>
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
Cc: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <467AC84A.303@assembler.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513223329.GA29207@dreamland.darkstar.lan>
	 <46520F36.4080006@assembler.cz>
	 <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com>
	 <46528B6F.3050701@assembler.cz>
	 <20070602222829.GA11893@dreamland.darkstar.lan>
	 <467AC84A.303@assembler.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Rudolf Marek <r.marek@assembler.cz> wrote:
> > Ok, it makes sense :)
> >
> > Name (FBUF, Package (0x06)
> > {
> >     0x03,
> >     CPUF,
> >     CHAF,
> >     PWRF,
> >     CHPF,
> >     CH2F
> > })
> >
> > Clearly the first number is not the number of available readings (though
> > it matches the count in the other DSDTs I've seen); don't know what it
> > is :|
>
> Maybe study the Pro2.dll from Asus Probe II?

Done that ;-) Disassembling is quite painful though, and most of the
work is performed by a kernel driver which I find a bit difficult to
decode.

Will fix the other issues and resend.

Luca
