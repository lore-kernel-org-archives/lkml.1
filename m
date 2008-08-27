Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYH0PH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYH0PH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYH0PHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:07:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYH0PHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:07:17 -0400
Date: Wed, 27 Aug 2008 08:04:38 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080827150438.GA30929@kroah.com>
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com> <20080823200446.GA24936@ldl.fc.hp.com> <20080825040713.GE3128@kroah.com> <20080827035003.GA25140@ldl.fc.hp.com> <20080827040135.GA23547@kroah.com> <20080827142139.GB19788@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827142139.GB19788@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 08:21:39AM -0600, Matthew Wilcox wrote:
> On Tue, Aug 26, 2008 at 09:01:35PM -0700, Greg KH wrote:
> > On Tue, Aug 26, 2008 at 09:50:03PM -0600, Alex Chiang wrote:
> > > * Greg KH <greg@kroah.com>:
> > > > And thanks for the other documentation as well, if you want,
> > > > you could split that out as a different patch and odds are
> > > > Jesse could get that into the tree before 2.6.27 comes out :)
> > > 
> > > Hrm, given the harder line Linus has taken against "regression
> > > only" patches lately, it can probably wait another release cycle.
> > 
> > Documentation updates and new stand-alone drivers are ok at all times :)
> 
> You're clearly not hanging on every word of our Dear Leader:
> 
> http://marc.info/?l=linux-kernel&m=121924636529367&w=2

I read that, and parsed:
	I generally won't complain about them, but I also don't see the
	point.

as being up to the maintainer's judgement.

So in this case, it's up to Jesse :)

thanks,

greg k-h
