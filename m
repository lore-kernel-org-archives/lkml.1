Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZKLWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZKLWA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZKLWAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:00:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59971 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbZKLWAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:00:52 -0500
Date: Thu, 12 Nov 2009 21:59:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben@simtec.co.uk>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Message-ID: <20091112215947.GB12308@n2100.arm.linux.org.uk>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com> <1257369899-325-2-git-send-email-fercerpav@gmail.com> <1257369899-325-3-git-send-email-fercerpav@gmail.com> <20091111134844.GB22476@home.pavel.comp> <20091111153143.GA1610@oksana.dev.rtsoft.ru> <20091112074059.GB11365@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112074059.GB11365@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 08:40:59AM +0100, Pavel Machek wrote:
> On Wed 2009-11-11 18:31:43, Anton Vorontsov wrote:
> > On Wed, Nov 11, 2009 at 04:48:44PM +0300, Paul Fertser wrote:
> > > Hi,
> > > 
> > > Ben, please give us an advice on how to proceed with this rather
> > > trivial patch. Anton doesn't merge the other patches from this series
> > > because we do not know via which tree to merge this particular patch.
> > 
> > Paul, I'll just merge the whole patch set but skip this particular
> > patch.
> 
> Feel free to merge that patch, too. It is clearly related to the
> other stuff, and Russell being totally unresponsive should not be
> reason to block patches.
> 
> He is the maintainer, he was cc-ed, and at this point it is quite
> clear that he does not care.

Err, WTF?  How do you come to the conclusion that I'm somehow related
to Samsung stuff, or GTA03 stuff?  Oh, that's right, you don't let facts
get in the way of blaming me for something.

The GTA03 stuff is Samsung stuff.  I've never had much to do with
Samsung stuff.  I'm certainly not the maintainer for it - that's
Ben Dooks domain.

I've been ignoring this because as far as I can see, it's got nothing
to do with me, and therefore its pointless me acking it.

Really Pavel, just take a moment to get your facts straight before you
start blaming people.
