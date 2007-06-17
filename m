Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXFQQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXFQQts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbXFQQtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:49:40 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:6646 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXFQQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=anS/guBd5vrLx4Lgrso+o+g0hOlszKG2Ed5YlbNrWrunWJEjPcYF3oL32y3IsQslZ0lA0N/2HuRwFvoJ1eoUiuXRdBF0IxWNkhkjX69gjggliq472/4eHFNfhDC2kkRPkeJ8ZXMYSSggjb8rfnjostZMM4+p1ysTVYAd63vDnD0=
Message-ID: <2accc2ff0706170949j26c391aek7ed32e0e55d9a3d1@mail.gmail.com>
Date: Sun, 17 Jun 2007 11:49:38 -0500
From: "Nelson Castillo" <nelsoneci@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: v2.6.21.4-rt11
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1182098605.8176.422.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070609210507.GA29194@elte.hu>
	 <2accc2ff0706170915h7cc0ce97ofc16bc33f1714567@mail.gmail.com>
	 <1182098605.8176.422.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 2007-06-17 at 11:15 -0500, Nelson Castillo wrote:
> > >      http://rt.wiki.kernel.org
> >
> > Not for ARM yet :(
> >
> > What should I try for the ARM architecture?
>
> ARM has a lot of sub architectures and not all of them are supported
> yet.

I see.

> > There are many choices and
> > I don't know what is the more friendly. By friendly I mean the one that
> > is likely to be merged and that cooperate with you.
>
> Which choices do you mean ?

I mean implementations. I've seen lot of them but i don't know which one
to try (I'm new to RT and the implementation in this thread seems to
be very nice).

>
> >   http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt14
> >
> > : undefined reference to `usecs_to_cycles'
> > make: *** [.tmp_vmlinux1] Error 1
>
> Which ARM sub arch ?

sub arch AT91 -- (Atmel AT91RM9200 processor).

Thanks,
Nelson.-


-- 
http://arhuaco.org
http://emQbit.com
