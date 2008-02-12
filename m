Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYBLVt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYBLVt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYBLVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:49:50 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:36270 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYBLVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w/JkKXqMQWc8wAtM22hz6at3aQbGkfgxZvejYYfDlbLf0jSZ4hwiqtBdYu8g0ucJ7EhiR9kfSOfqSw/6flCi3I1LpqvsaIK6OkooCVWlLez9DnSBlV9s0dA5CU0ed+y8+28YJs6+yaZyyy3o2tndB3ioZeqjpBG7yxd3DtMdRCs=
Message-ID: <6101e8c40802121349r4477ec95lbfb15a10cb75d5e4@mail.gmail.com>
Date: Tue, 12 Feb 2008 22:49:47 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Mike Snitzer" <snitzer@gmail.com>, "Willy Tarreau" <w@1wt.eu>
Subject: Re: currently active Linux kernel versions
Cc: "Ferenc Wagner" <wferi@niif.hu>, "Xavier Bestel" <xavier.bestel@free.fr>,
       linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87skzx53a9.fsf@szonett.ki.iif.hu>
	 <1202850783.6697.0.camel@bip.parateam.prv>
	 <87wsp9q3ev.fsf@szonett.ki.iif.hu>
	 <170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Willy go in 2.6.22.y, then I help it, so far as I 'm possible.

On 2/12/08, Mike Snitzer <snitzer@gmail.com> wrote:
> On Feb 12, 2008 4:18 PM, Ferenc Wagner <wferi@niif.hu> wrote:
> > Xavier Bestel <xavier.bestel@free.fr> writes:
> >
> > > On mar, 2008-02-12 at 21:27 +0100, Wagner Ferenc wrote:
> > >
> > >> which are the "currently active Linux kernel versions" at any point in
> > >> time?  The quote is taken from http://lkml.org/lkml/2008/2/11/29.
> > >> Or more precisely: which are the "stable" versions I can depend on for
> > >> a more or less critical server, those that have active security
> > >> support or receive at least critical bugfixes?  I know about the
> > >> 2.6.2[34].y stable git trees, but I wonder how long will those receive
> > >> attention (that is, security fixes).  Can I find a written policy
> > >> somewhere?
> > >
> > > The answer is at http://kernel.org/
> >
> > Not quite, at least I can't find 2.6.23.y there, even though that
> > branch seems to be maintained...
>
> 2.6.16.x is still maintained (2.6.16.60 was recently released).
>
> 2.6.22.x is still maintained but Greg KH is apparently going to be
> ending his duties on it after the next release or so.  There is some
> confusion as to whether Willy Tarreau will be taking on the 2.6.22.x
> tree once Greg is done, Willy?:
> http://lwn.net/Articles/268003/
> http://kerneltrap.org/Linux/Stable_2.6_Branches
>
> 2.6.23.x and 2.6.24.x are obviously quite active for stable@kernel.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
