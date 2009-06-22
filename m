Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZFXUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZFXUCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZFXUCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:02:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56039 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZFXUCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:02:05 -0400
Date: Mon, 22 Jun 2009 21:43:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090622194303.GC2284@ucw.cz>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-23 14:41:28, Len Brown wrote:
> On Tue, 23 Jun 2009, Matthew Garrett wrote:
> 
> > There seems to be a huge amount of overlap between SFI and ACPI.
> > Couldn't this have simply taken the form of some additional ACPI tables 
> > and a decoupling of ACPI enumeration from runtime AML interpretation? 
> > How final is this spec?
> 
> > I realise that we're pretty much constrained to implementing this if 
> > hardware actually ships with it, but it seems to be an additional 
> > firmware interface with no real benefit - as far as I can tell it's not 
> > possible for a platform to meaningfully implement both ACPI and SFI 
> > without duplicating information?
> 
> Please let me know if your questions are not thoroughly answered here:
> http://simplefirmware.org/faq

It really tells us nothing. I don't think flash got so expensive that
this is justified. ACPI can already do the job, right? and operating
systems already have to support ACPI. So what are the reasons to
reinvent the wheel?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
