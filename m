Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbXFTXej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbXFTXej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXFTXea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:34:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:18752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXFTXe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=i7odN3wgrrdOaYY1nEaJlsmE0Vv42rKgSBdwPz8qCk6yQ8vnkKET7PcmYjIB+ztZ8WjiOGNlW23ElNgSKaUIY+X1Tw8xZKPZOq+CE4CpK26AB6GD0MtJ702N1F8urgfT32TEEVD12X1wpUX0t4FgT0634iFmNPPwhHwrckwPi+Q=
Message-ID: <161717d50706201634m68992ddeqb1d7557fb43c0822@mail.gmail.com>
Date: Wed, 20 Jun 2007 19:34:28 -0400
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: davids@webmaster.com
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Tomas Neme" <lacrymology@gmail.com>, mdpool@troilus.org,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEBIEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <871wg6trnx.fsf@graviton.dyn.troilus.org>
	 <MDEHLPKNGKAHNMBLJOLKMEBIEMAC.davids@webmaster.com>
X-Google-Sender-Auth: 497564e6f0fc5135
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, David Schwartz <davids@webmaster.com> wrote:
>
> > Tomas Neme writes:
>
> > > I have been following this discussion for the last week or so, and
> > > what I haven't been able to figure out is what the hell is the big
> > > deal with TiVO doing whatever they want to with their stupid design.
> > > They made a design, they build a machine, they sell it as is, and
> > > provide source code for GPL'ed software... what's your problem?
>
> > It's simple: they don't provide _complete_ source code.  They keep the
> > source code for the part of their Linux kernel images that provides
> > the functionality "runs on Tivo DVRs".  The GPL requires that
> > distributors of binary versions provide complete source code, not just
> > the parts of source code that are convenient.
> >
> > Michael Poole
>
> That leads to lots of obvious nonsense unless you fix it with all kinds of
> made up ad-hoc changes just to get the result you want. Why doesn't Linus
> have to release the keys he uses to sign the Linux kernel source
> distributions? That provides the functionality "can be proven to be
> authorized by Linus". What you call "runs on Tivo DVRs", I call "can be
> proven to be authorized by Tivo to run on Tivo DVRs".

This argument is the obvious nonsense. "Runs on TiVO" is a property of
the software that TiVO distributes -- such an important property that
it would be nonsensical for them to distribute it with their hardware.
But they do distribute it, and only the GPL allows them to.

Linus' key is not required to use the software Linus distributes under
the GPL, by contrast.

>
> Tivo's choice is an authorization decision. It is similar to you not having
> root access to a Linux box. Sorry, you can't run a modified kernel on that
> machine, but you can still modify the kernel and run it on any hardware
> where authorization decisions don't stop you from doing so. The GPL was
> never about such authorization decisions.

Says judge Schwartz. Oops. That's right, you're not a judge in any
legal jurisdiction, nor an author of the GPL.

Dave
