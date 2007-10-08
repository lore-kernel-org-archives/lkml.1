Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXJHDrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXJHDrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 23:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXJHDr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 23:47:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10526 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXJHDrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 23:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tKiNMwOp0Q+BMZC6KPfiK5LR3QP2EKGbJxpatfKX6std580xkN81TE1rfh14/TeGK97aY0JjdTa+/0euiFEnhPrUwowahioiK/Ipkkx8hBQyRlrS8C8TA9t8t1D773GIuY5xkALCY67kUX6dl+6ZTgpoytwFKEEvVeoQDVME2vU=
Message-ID: <29495f1d0710072047k2790d767t2da9f018d91e5b20@mail.gmail.com>
Date: Sun, 7 Oct 2007 20:47:23 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Linas Vepstas" <linas@austin.ibm.com>
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Cc: "Tony Breeds" <tony@bakeyournoodle.com>,
       "Michael Ellerman" <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071005160322.GN4338@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <20070924123531.GC30855@shadowen.org>
	 <20071002232819.GN4338@austin.ibm.com>
	 <20071003002646.GD9814@bakeyournoodle.com>
	 <1191371416.8073.1.camel@concordia>
	 <20071003011909.GG9814@bakeyournoodle.com>
	 <29495f1d0710041701g4ed73441ie583058c78f95857@mail.gmail.com>
	 <20071005160322.GN4338@austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Linas Vepstas <linas@austin.ibm.com> wrote:
> On Thu, Oct 04, 2007 at 05:01:47PM -0700, Nish Aravamudan wrote:
> > On 10/2/07, Tony Breeds <tony@bakeyournoodle.com> wrote:
> > > On Wed, Oct 03, 2007 at 10:30:16AM +1000, Michael Ellerman wrote:
> > >
> > > > I realise it'll make the patch bigger, but this doesn't seem like a
> > > > particularly good name for the variable anymore.
> > >
> > > Sure, what about?
> > >
> > > Clarify when RTAS logging is enabled.
> > >
> > > Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> >
> > For what it's worth, on a different ppc64 box, this resolves a similar
> > panic for me.
> >
> > Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>
>
> For the reasons explained, I'd really like to nack Tony's patch.

I see. Can you reply in this thread with the patch you mentioned in
your other reply? (or point me to a copy of it)

Thanks,
Nish
