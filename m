Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXEBESZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXEBESZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXEBESZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:18:25 -0400
Received: from gw.goop.org ([64.81.55.164]:44247 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXEBESY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:18:24 -0400
Message-ID: <46381106.8010605@goop.org>
Date: Tue, 01 May 2007 21:18:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: netfront for review
References: <4637D672.5030706@goop.org> <1178077033.28659.173.camel@localhost.localdomain>
In-Reply-To: <1178077033.28659.173.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-05-01 at 17:08 -0700, Jeremy Fitzhardinge wrote:
>   
>> Add the Xen virtual network device driver.
>>     
>
> (Herbert: there's a question for you: grep for Herbert)
>
> OK, this is a remarkably non-trivial driver.  If the v0.1 of the driver
> had been in the kernel, I'm sure it would have been about 1/4 the size
> and far easier to review 8(
>
> Nonetheless, I have scoured the entire thing.  It's not actually too
> bad.
>   

Lovely, thanks.  I'm at the double disadvantage of not really knowing
how the network stack works or precisely how Xen does networking, but
the homework exercises ("comment this") will definitely help my education.

    J
