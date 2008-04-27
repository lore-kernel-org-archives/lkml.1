Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbYD0Tvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbYD0Tvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbYD0Tvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:51:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:18962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762952AbYD0Tvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OLIXPE3nEZ/2c7f2Ci9va/S+QgBrnuDKuL+6rZRnbME50rw8AngXIT1KpJ3AKMKU0yzz4E1DOmLjX5M59h+krqLon/f3OlyPbFL7pHqMh+FIm1ISjiPB8csTt7wG9uO1NjRrOkFsv50107ApXzt05Nv982iytTlrJLTVZZ5knPU=
Message-ID: <6101e8c40804271251q3eb33e0s3d8bf920e43ae08c@mail.gmail.com>
Date: Sun, 27 Apr 2008 21:51:41 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: A system for rebootless kernel security updates
Cc: "Pavel Machek" <pavel@ucw.cz>, "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, jbarnold@mit.edu,
       francois.cami@free.fr, "Andi Kleen" <andi@firstfloor.org>,
       mail@earthworm.de
In-Reply-To: <20080427174947.GI8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481098A4.50107@wpkg.org> <20080427101659.GD3891@ucw.cz>
	 <20080427174947.GI8474@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and if i good know, the macos make too the kernel updates

On 4/27/08, Willy Tarreau <w@1wt.eu> wrote:
> On Sun, Apr 27, 2008 at 12:17:00PM +0200, Pavel Machek wrote:
> > On Thu 2008-04-24 16:26:44, Tomasz Chmielewski wrote:
> > > Jeff Arnold wrote:
> > >
> > > >I've put together an automatic system for applying
> > > >kernel security patches to the Linux kernel without
> > > >rebooting it, and I wanted to share this system with
> > > >the community in case others find it useful or
> > > >interesting.
> > >
> > > Hmm, the idea seem to be patented by Microsoft, i.e.
> > > this patent from December 2002:
> > >
> > > http://www.google.com/patents?id=cVyWAAAAEBAJ&dq=hotpatching
> > >
> > > (and other patents by Microsoft if you search for
> > > "hotpatching").
> >
> > ...so US will not be able to fix security holes without reboot, good.
> > Perhaps they fix their stupid laws after next worm outbreak...
>
> Sounds like a bullshit patent. I remember having loaded a lot of NLM
> patches under netware 4.0 in 96-97 without ever rebooting. I think
> that the patches only redefined the faulty symbol(s) they wanted to
> patch. That was pretty convenient because when in doubt, you could
> simply unload the modules and get back to previous situation.
>
> > 							Pavel
>
> Willy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
