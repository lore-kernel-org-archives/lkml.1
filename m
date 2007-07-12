Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXGLSgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXGLSgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXGLSfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:35:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:31759 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXGLSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bijUuQvJ6nwA2ezMYLLfhGkp/OZBGZxczZSXqCN2SbjF0iUlXqLZ+Y8iIzROrVZGYXy7GQCfa0BR1vbelUlPtQ3sjK1pWotU0SUhHZmMX02QfiJYv9CvuzgyL6IKLPWXWX1UDiR/gsvV7qjsX6K9OHyKztuEf2ZLISQ6v9212Jk=
Message-ID: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
Date: Thu, 12 Jul 2007 11:35:41 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Linux 2.6.22.1
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20070710200637.GA5881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710200637.GA5881@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Greg KH <greg@kroah.com> wrote:
> We (the -stable team) are announcing the release of the 2.6.22.1 kernel.
> It contains a security fix for SCTP that somehow forgot to be added to
> the 2.6.22 kernel (was already released in the 2.6.21.y releases).
> Thanks to Patrick McHardy for noticing the mistake.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.22 and 2.6.22.1
>
> The updated 2.6.22.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git

Can you please also update

 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git

? Maybe make that update part of whatever process you use to push out
the 2.6.Y trees, as I've had to ask for this more than once now?

Thanks,
Nish
