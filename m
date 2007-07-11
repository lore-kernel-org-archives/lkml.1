Return-Path: <linux-kernel-owner+w=401wt.eu-S1764764AbXGKOYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764764AbXGKOYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbXGKOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:24:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:44497 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbXGKOYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r7CbC2RRlmqoB7cUA24+dqzhEeCnmtGDpV8k0D86dEVku+N10g+XmPtQREMu55bZOYVzL+okS8k/Hhz4vWF3JS+xmfAFPfQl2kAAa8gx5Gfq7jKoOmSid8t1sT0DSl8uALXiHFXOY1XHU/N9dG6girEjGB5JWPpvVW7acV6UW2Y=
Message-ID: <a781481a0707110724s11cc51c4p1ed54466945258f3@mail.gmail.com>
Date: Wed, 11 Jul 2007 19:54:13 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Gerb Stralko" <gerb.stralko@gmail.com>
Subject: Re: Gmail and flowed text (was Re: Correction to LZO1X)
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <75b57c110707110652h24166093ra063731f0c2a90a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
	 <9a8748490707110641y1796d5dy42d4f744f131fbc9@mail.gmail.com>
	 <75b57c110707110652h24166093ra063731f0c2a90a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/11/07, Gerb Stralko <gerb.stralko@gmail.com> wrote:
> > 2) If you have a box available at home (or elsewhere), use that to
> > relay mail through.
> >
> read linux mail from you gmail account. When you need to send a patch,
> send it from a linux box using pine, but change the From to your gmail
> account.   Like Jesper suggested works great!  Best of both worlds.

Just changing the "From:" in pine (configured for my other account)
wouldn't solve the problem. I'd have to first forward the original mail
to my other account and/or copy it manually, which I'd like to avoid ...

> This link will help:
> http://www.ii.com/internet/messaging/pine/pc/#gmail
>
> Scroll down untill you see a yellow box section that say:
> Gmail Tips
>     * If you want to use the Gmail SMTP server for your outgoing
> messages, I recommend that you create a Pine Role that includes these
> ACTIONS:

Ok, I read through the relevant bits of that page, thanks. My box
here doesn't resolve smtp.gmail.com / pop.gmail.com and there
could be firewalling issues on top of that, so I'm not too hopeful ...
but I'll give it a try definitely.

Thanks,
Satyam
