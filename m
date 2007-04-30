Return-Path: <linux-kernel-owner+w=401wt.eu-S1423217AbXD3MvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423217AbXD3MvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423219AbXD3MvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:51:06 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:8224 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423217AbXD3MvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=btf96v4PiNNUhWIjolkUms1TOgxZAHx3hiDQbQAE2QM2QIwMKnymcWk0o5BTL4cwgkB7JEYluTeNqcyb2zQ3KJ4u10uYb4MuoxLw52T0zYGkM6Lmt17fqU0opYxPwmUPjCStwYC+Ndg/9gmeUErSPB9pDmljoIjKKfnnm6OKP1I=
Message-ID: <8f8ff01d0704300551yb0413c7m3834cc75c2d0fcdd@mail.gmail.com>
Date: Mon, 30 Apr 2007 16:51:02 +0400
From: "Alexey Starikovskiy" <aystarik@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21: ACPI related kernel panic
Cc: "Sebastian Kemper" <sebastian_ml@gmx.net>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0704300546w1eff1a92gff047117e9e756e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430122940.GA25848@anna.darkstar.lan>
	 <6bffcb0e0704300546w1eff1a92gff047117e9e756e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please take a look at 8385 bug report here, as it might be relevant:
http://bugzilla.kernel.org/show_bug.cgi?id=8385

On 4/30/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi,
>
> On 30/04/07, Sebastian Kemper <sebastian_ml@gmx.net> wrote:
> > Hello all,
> >
> > I have updated some different boxes to 2.6.21 with success. One laptop,
> > though, has some issue with it.
> >
> > It's an Acer TravelMate 4002WLMi. Sometimes it boots fine and sometimes
> > not. Thanks to netconsole you can see what happens when it boots fine in
> > the attached bootsie.out.good. bootsie.out shows what happens on the
> > screen when things get out of hand (kernel panic).
> >
> > Also attached you'll find the output of lspci, lsusb, ver_linux and the
> > kernel configuration.
> >
> > If there's more you need (git bisection or more info in general,
> > testing ...) just say so.
> >
> > Thanks in advance!
> >
> > Regards
> > Sebastian
> >
> > P.S.: Please CC.
> >
> >
>
> I added this to the list of known regressions.
>
> Len and ACPI folks CC'ed.
>
> Regards,
> Michal
>
> --
> Michal K. K. Piotrowski
> Kernel Monkeys
> (http://kernel.wikidot.com/start)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
