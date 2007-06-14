Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbXFNP42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbXFNP42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXFNP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:56:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:27950 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXFNP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G7gaMXhRjs6rVkMt/AbA9yhzFt0ki4VfSN1wfbr5ndfiEyt3sgQQAKGP5tzh/vHEqpWnubN3YlXDl1uvOa9DanD+4D0Y0j/OlgV6cGrbfMw3IvHoKq3uU05DGvpYONvabspMsQRS/tWdDlwwerAb8rL+inT27UZRgNa4ASH9ZKQ=
Message-ID: <d120d5000706140856s5fdb29c6j1b53cafc291f8ec1@mail.gmail.com>
Date: Thu, 14 Jun 2007 11:56:10 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Bongani Hlope" <bhlope@mweb.co.za>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <orps3zghgo.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	 <200706132108.50030.dhazelton@enter.net>
	 <orlkenjnxm.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200706140125.24815.dtor@insightbb.com>
	 <orps3zghgo.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 14, 2007, Dmitry Torokhov <dtor@insightbb.com> wrote:
>
> > On Wednesday 13 June 2007 21:59, Alexandre Oliva wrote:
> >> For example, if you distribute copies of such a program, whether
> >> gratis or for a fee, you must give the recipients
> >> all the rights that you have.
> >> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> > So if I am a sole author of a program and I chose to distribute it under
> > GPL
>
> then you're not a licensee, you're a licensor, and these terms don't
> apply to you.

Heh. When you change a GPLed program and pass your changes you are the
licensor for the new code. You still have a right and license pieces
of the code you wrote under different license but you do not pass that
right to recepient of modified work.

-- 
Dmitry
