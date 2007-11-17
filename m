Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbXKQKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbXKQKf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXKQKfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:35:20 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:57789 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXKQKfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:35:19 -0500
Date: Sat, 17 Nov 2007 11:35:16 +0100
Message-Id: <2090717360@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: ewanm89@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: distro specific kernels vs vanilla kernel and how to compare
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+E2ZGIHRXsXipx+CG+/6Xv7TTN5D6ipHvhQ1txV0YejXiGs
 WWasEpudg+bMuoQn3hxILdQKto0ontNz/Blexnnqj8rMtObRCM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I would also like to see something like this
nice to get positive feedback, thanks :)

>as some work I'm doing on
>working some funny networking (unfortunately IT department don't have
>common sense) across multiple distros.

so if _you_ have common sense, it`s up to you alone to make your own life easier and you should try hard to change their mind.
how can you make sure your code is good and stable if other`s don`t review it ?
why should you constantly work on porting your code to the next kernel release ?
even worse, you need to port it to different vendor specific kernels. that`s a real waste of time...
please try changing their minds and if you need some help/arguments i`m sure there are people who can help you freeing the source ! ;)
maybe you will find some at http://www.kroah.com/log/linux/ols_2006_keynote.html 

regards
roland


List:       linux-kernel
Subject:    Re: distro specific kernels vs vanilla kernel and how to compare
From:       ewanm89 <ewanm89 () googlemail ! com>
Date:       2007-11-17 5:17:56
Message-ID: 20071117051756.4b1d20da () ewanm89-laptop
[Download message RAW]

On Fri, 16 Nov 2007 23:25:27 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> devzero@web.de writes:
> 
> > does somebody know if there is a website or a project for giving
> > comfortable and deeper insight into what`s specific to distro`s
> > kernels and what`s their difference to vanilla kernel ?
> >
> > i mean some way to have some transparancy to what different distro
> > vendors add to vanilla kernel sources and thus turning it into
> > their own specific version. 
> 
> There used to be such a page at kernelnewbies, but at some point it
> disappeared.
> 
> I agree it would be a useful resource.
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I would also like to see something like this, as some work I'm doing on
working some funny networking (unfortunately IT department don't have
common sense) across multiple distros. Tracking the kernel patche
differences between the distros seems to be the hardest part (comparing
them to find what's needed for all distros to work).

-- 
Ewan Marshall (ewanm89)
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

