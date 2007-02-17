Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbXBQWSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbXBQWSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXBQWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:18:48 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:63770 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbXBQWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jJOHaNMROEVaCFiJCNcoRIcY/qHSBVf2OlcqvarRk3mr3dJhL7FdV/kVRvkRRDnuGWELD3L76KS05XLrsCfAv/MhhROmBpiYGHSNxjvWiTsEeRpTXjnTdDkbmnfiA+GrGoXH98eZk9oKDPGGB66AIXCr6qM6BRBe201xPVDuhHY=
Message-ID: <161717d50702171418w2eecc38bse12df666e974a08b@mail.gmail.com>
Date: Sat, 17 Feb 2007 17:18:45 -0500
From: "Dave Neuer" <mr.fred.smoothie@gmail.com>
Reply-To: mr.fred.smoothie@pobox.com
To: davids@webmaster.com
Subject: Re: GPL vs non-GPL device drivers
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEIMBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <161717d50702160912x6dc4efbahcfb02f665ae3ec8a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEIMBKAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, David Schwartz <davids@webmaster.com> wrote:
>
> > On 2/16/07, David Schwartz <davids@webmaster.com> wrote:
>
> > > (See, among other cases, Lexmark. v. Static
> > > Controls.) A copyright is not a patent, you can only own
> > > something if there
> > > are multiple equally good ways to do it and you claim *one* of them.
>
> > Only in a world where "write a Linux module" is a "functional idea." I
> > don't think that the legal world in the US is an example of such a
> > world, though you clearly do.
>
> I'm not arguing "write a Linux module" is a functional idea. But "write code
> so that a graphics card with a X1950 chipset works with a Linux kernel"
> certainly is.
>
> Again, see Lexmark v. Static Controls. If "make a toner cartridge that works
> with a particular Lexmark printer" is a functional idea, why is "make a
> graphics driver that works with a particular Linux kernel" not? What is the
> difference you think matters?

I think you are reading Lexmark wrong. First off, Lexmark ruled that
scenes a faire applied to the toner-level calculation, not "make a
toner cartridge that works with a particular Lexmark printer." It was
the toner-calculation algorithm that could't be done any other sane
way, which made the TLP unprotectable via copyright. The opinion says,
"Both prongs of the infringement test, in other words, consider
'copyrightability,' which at its heart turns on the principle that
copyright protection extends to expression, not to ideas."

You're saying that there's no other way to interface device drivers to
an operating system than the current Linux driver model? That's
strange, since it's a different driver model than Linux had
previously, and it's also different from the BeOS driver interface,
etc. If the Linux driver interface is protectable, it doesn't seem
like scenes a faire applies.
