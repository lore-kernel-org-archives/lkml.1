Return-Path: <linux-kernel-owner+w=401wt.eu-S1030420AbXBOSUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420AbXBOSUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030448AbXBOSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:20:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:5815 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030420AbXBOSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JvOcw3Jxm0Hh7ium4cBswGrULbDLd1zYjOmDrBl924dsvG1baO4fugmD05SkHdGqLhqC7SG49z4iPtEGhMVIFLTY0bukYEl684kgvQ/cBuybeN4Q50KxZXHX9ka0SGhED/YMdjjize4X5+3Hv611uhdia6SwEPVfqFi1xG7snps=
Message-ID: <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
Date: Thu, 15 Feb 2007 10:20:13 -0800
From: "v j" <vj.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "v j" <vj.linux@gmail.com>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <20070215165339.GB5285@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So far I have heard nothing but, "if you don't contribute, screw you."
All this is fine. Just say so. Make it black and white. Make it
perfectly clear what is and isn't legal. If we can't load proprietary
modules, then so be it. It will help everybody if this is out in the
clear, instead of resorting to stupid half measures like
EXPORT_SYMBOL_GPL.

On 2/15/07, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Feb 14, 2007 at 10:27:10PM -0800, v j wrote:
> > You are right. I have not contributed anything to Linux. Except one
> > small patch to the MTD code. However, I don't think that is the point
> > here. I am perfectly willing to live with the way Linux is today. I am
> > telling you as a user that if Linux continues on the current path it
> > will become less and less attractive to Embedded Users.
>
> But so what?  How will that hurt *Linux*?  If the Embedded developers
> don't contribute changes back, it doesn't hurt us any if they go away
> and start paying $$$ to VxWorks instead of using Linux for free.
>
> Contrawise, if Embedded developers do contribute their device driver
> changes back to the kernel, they will be fine.  Note that we don't
> even force them to do the work to make it be mainline acceptable; they
> just have to make the sources available.  It could be crap code, but
> it will fulfill the requirements of the the GPL.  Others in the
> community can make the decision about whether they want to clean up
> the code and get it mainlined, or it ignore it if it truly is a
> one-off driver.  All you have to do is make the driver available.
>
> And if you don't, why do you think that it is at all a credible
> threat, or that we should shed even one tear, if you go away and use
> some other OS for your embedded product?  It's not like in the case of
> VxWorks where you get to say, "Do X or we take away a million dollars
> worth of business."  And on the flip side, what I think you will find
> is that if you do contribute to the community and be a good community
> member, others will cut you some slack when the time comes because
> you've built up the good karma.  But that requires that you be a good
> community member.  If in contrast you find that it's cheaper to pay
> $$$ to some embedded OS company, please feel free to do this.  No one
> is forcing you to move from Linux 2.4 to Linux 2.6, or even to stay
> with Linux.
>
>                                                         - Ted
>
