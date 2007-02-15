Return-Path: <linux-kernel-owner+w=401wt.eu-S966139AbXBOQyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966139AbXBOQyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966140AbXBOQyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:54:08 -0500
Received: from THUNK.ORG ([69.25.196.29]:36814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966139AbXBOQyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:54:07 -0500
Date: Thu, 15 Feb 2007 11:53:39 -0500
From: Theodore Tso <tytso@mit.edu>
To: v j <vj.linux@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070215165339.GB5285@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, v j <vj.linux@gmail.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:27:10PM -0800, v j wrote:
> You are right. I have not contributed anything to Linux. Except one
> small patch to the MTD code. However, I don't think that is the point
> here. I am perfectly willing to live with the way Linux is today. I am
> telling you as a user that if Linux continues on the current path it
> will become less and less attractive to Embedded Users.

But so what?  How will that hurt *Linux*?  If the Embedded developers
don't contribute changes back, it doesn't hurt us any if they go away
and start paying $$$ to VxWorks instead of using Linux for free.  

Contrawise, if Embedded developers do contribute their device driver
changes back to the kernel, they will be fine.  Note that we don't
even force them to do the work to make it be mainline acceptable; they
just have to make the sources available.  It could be crap code, but
it will fulfill the requirements of the the GPL.  Others in the
community can make the decision about whether they want to clean up
the code and get it mainlined, or it ignore it if it truly is a
one-off driver.  All you have to do is make the driver available.

And if you don't, why do you think that it is at all a credible
threat, or that we should shed even one tear, if you go away and use
some other OS for your embedded product?  It's not like in the case of
VxWorks where you get to say, "Do X or we take away a million dollars
worth of business."  And on the flip side, what I think you will find
is that if you do contribute to the community and be a good community
member, others will cut you some slack when the time comes because
you've built up the good karma.  But that requires that you be a good
community member.  If in contrast you find that it's cheaper to pay
$$$ to some embedded OS company, please feel free to do this.  No one
is forcing you to move from Linux 2.4 to Linux 2.6, or even to stay
with Linux.

							- Ted
