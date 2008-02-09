Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYBITDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYBITDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYBITD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:03:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:47059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYBITD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J6YPgWWicEbqfeNbBANlXnWLMcT52m7c5iR99y6ZMJ64w/N7QuJFL4uGB/9exfB/k2tYcFcj2DIKO06v2tEBAYEgEW9S6aVQzY4+NKNZON2RTiyLSMSGGPCdcbBrOWyGXGLXDYF+Q5EwbhfDa6ykTVYOobrlvpwe4Uv2Xzjkz3E=
Message-ID: <6101e8c40802091103l66d1cb00ubbf4579c44bfcde6@mail.gmail.com>
Date: Sat, 9 Feb 2008 20:03:26 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Chris Rankin" <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1 - kernel does not boot; IRQ trouble?
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <869708.29623.qm@web52902.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080209180633.GB20784@kroah.com>
	 <869708.29623.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

here is the snapshots in patch format:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots

On 2/9/08, Chris Rankin <rankincj@yahoo.com> wrote:
> --- Greg KH <greg@kroah.com> wrote:
> > Does any older kernel version work?  2.6.23?  Newer ones?
> Everything up to and including 2.6.23.11 works fine. I never tried
> 2.6.23.{12,13,14,15}, but I
> expect they're fine too.
>
> >  2.6.24-git15?
> No idea. This box isn't really set up to use git. Anyway, I would refer you
> to this thread:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0802.0/0898.html
>
> Cheers,
> Chris
>
>
>
>       ___________________________________________________________
> Support the World Aids Awareness campaign this month with Yahoo! For Good
> http://uk.promotions.yahoo.com/forgood/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
