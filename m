Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXEWSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXEWSsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEWSs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:48:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:20152 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbXEWSs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MDtCYoxYFezDA/Vmvh4wqMfTpf/uxQwx9LjCu9XWYOdFp0KQt79LSmuIJmRHMROTxOamrq3+qTSPk+JFyPYce7umTgrKtZRUKlhSr3Cq5K3qEETwyu57cRQNrtYT0Y829RJ6j379eEYI++SJd10C4JvahqimWmX+EFA7E+7ctcQ=
Message-ID: <75b57c110705231148t630ad7f8n6b9be46075c66cbf@mail.gmail.com>
Date: Wed, 23 May 2007 14:48:27 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: rmk+lkml@arm.linux.org.uk
Subject: Re: [PATCH] ARM/ARM26 Cleanup, using ARRAY_SIZE
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070523181034.GC1976@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <75b57c110705231027l4d0aeca5u778cb907dbd7c814@mail.gmail.com>
	 <20070523181034.GC1976@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Wed, May 23, 2007 at 01:27:11PM -0400, Gerb Stralko wrote:
> > Use the kernel wide ARRAY_SIZE when determining the array size of a struct.
> >
> > Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
>
> Whitespace damanged patch, probably due to using format=flowed in your
> mailer.  Please get a proper mail client. 8)

Sorry about that one.  I didn't realize my mailer was being stupid.
I'll see if I can fix _or_  get a new mailer, and maybe send out a
better patch :)

> Also, please note that ARM and ARM26 are two separate architectures
> maintained by two separate people.  Please don't confuse them and
> merge patches - it's about the same level of evilness as labelling
> PPC and i386 as one architecture and expecting PPC folk to take the
> lot.

Ok, sorry about that, I don't want to cause you any more confusion or
frustration.  I'm a newbie in this area and just wanted to help out
and learn.  Thanks for being polite about it...instead of chewing my
head off - your a good man.

> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>
