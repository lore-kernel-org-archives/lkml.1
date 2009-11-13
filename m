Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZKMS02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZKMS02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZKMS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:26:22 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:52975 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZKMS0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:26:22 -0500
Date: Fri, 13 Nov 2009 19:26:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben@simtec.co.uk>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Message-ID: <20091113182621.GA1368@ucw.cz>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com> <1257369899-325-2-git-send-email-fercerpav@gmail.com> <1257369899-325-3-git-send-email-fercerpav@gmail.com> <20091111134844.GB22476@home.pavel.comp> <20091111153143.GA1610@oksana.dev.rtsoft.ru> <20091112074059.GB11365@elf.ucw.cz> <20091112215947.GB12308@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112215947.GB12308@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-12 21:59:47, Russell King - ARM Linux wrote:
> On Thu, Nov 12, 2009 at 08:40:59AM +0100, Pavel Machek wrote:
> > On Wed 2009-11-11 18:31:43, Anton Vorontsov wrote:
> > > On Wed, Nov 11, 2009 at 04:48:44PM +0300, Paul Fertser wrote:
> > > > Hi,
> > > > 
> > > > Ben, please give us an advice on how to proceed with this rather
> > > > trivial patch. Anton doesn't merge the other patches from this series
> > > > because we do not know via which tree to merge this particular patch.
> > > 
> > > Paul, I'll just merge the whole patch set but skip this particular
> > > patch.
> > 
> > Feel free to merge that patch, too. It is clearly related to the
> > other stuff, and Russell being totally unresponsive should not be
> > reason to block patches.
> > 
> > He is the maintainer, he was cc-ed, and at this point it is quite
> > clear that he does not care.
> 
> Err, WTF?  How do you come to the conclusion that I'm somehow related
> to Samsung stuff, or GTA03 stuff?  Oh, that's right, you don't let facts
> get in the way of blaming me for something.

Ok, you are right, Ben is listed as Samsung maintainer. Accept my
apologies. The rest stands: Anton should just take the patch, because
maintainer does not care.

Actually, given that Ben is unresponsive, it should be either you or
Anton taking the patch; so if you prefer, you can take it.

> I've been ignoring this because as far as I can see, it's got nothing
> to do with me, and therefore its pointless me acking it.
> 
> Really Pavel, just take a moment to get your facts straight before you
> start blaming people.

Now, you still are arm maintainer, and that includes arch-msm. There's
nice series in your inbox for week+ -- HTC Dream support. There's also
Daniel Walker who is willing to maintain the architecture. Can we get
the patches applied (or some other decision?).  Pavel

-- (english)
http://www.livejournal.com/~pavelmachek (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
