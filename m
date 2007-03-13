Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbXCMBy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbXCMBy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 21:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXCMBy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 21:54:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32530 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbXCMBy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 21:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lj6hQqSowQq4VmUkki6DXceCgdLQTyL6fWtpsa5jMKJBBWwZv26YupTR9zAS8/WeZK9A9joHgdmG6glYtWLIY7MDNJjxzT3wVYQeM2TWGNo4rmdgKFSjSibRupcucGDS5/BmmsamPozbtfMkhYddf7C9bwtcO2+ipnXmo0DdDGQ=
Message-ID: <a8e1da0703121854h161ddf2fib0235cd392b5977b@mail.gmail.com>
Date: Tue, 13 Mar 2007 01:54:53 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Fwd: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
In-Reply-To: <a8e1da0703121849y202b7e3clb39afca72731762d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051414.15802.frafore@tiscali.it>
	 <1173143894.3461.240.camel@pmac.infradead.org>
	 <87tzwzqgrx.fsf@briny.internal.ondioline.org>
	 <1173177329.3461.291.camel@pmac.infradead.org>
	 <873b4h64dm.fsf@briny.internal.ondioline.org>
	 <1173265479.9349.51.camel@localhost.localdomain>
	 <a8e1da0703121849y202b7e3clb39afca72731762d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
Hi,
I have tested on my mac mini g4.

The 2.6.21-rc2 will cause oops like the above post.

And for the new 2.6.21-rc3-git7 , the kernel load ok,  penguin pixmap
appears, but then it stopped, there's no error messages also.

Regards
dave


2007/3/7, Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Wed, 2007-03-07 at 17:53 +1300, Paul Collins wrote:
> > David Woodhouse <dwmw2@infradead.org> writes:
> >
> > > On Tue, 2007-03-06 at 14:53 +1300, Paul Collins wrote:
> > >> In case it's of interest, 2.6.20 has been running fine on my
> > >> PowerBook5,4.
> > >
> > > How much memory? What if you boot with mem=512M or mem=256M?
> >
> > 1GB.  Also works fine when booted with those options.
>
> Can you try 2.6.21-rc3 ? We just fixed a nasty bug causing memory
> corruption.
>
> Ben.
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>
