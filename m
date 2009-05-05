Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbZEFPYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbZEFPYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZEFPYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:24:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47025 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZEFPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:24:20 -0400
Date: Tue, 5 May 2009 21:49:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Bank screen after resume on Dell XPS M1330
Message-ID: <20090505194902.GC1379@ucw.cz>
References: <200905031111.50789.arvidjaar@mail.ru> <200905031543.28977.arvidjaar@mail.ru> <20090503115603.GA18880@srcf.ucam.org> <200905040627.36297.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905040627.36297.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-04 06:27:35, Andrey Borzenkov wrote:
> On Sunday 03 of May 2009 15:56:03 Matthew Garrett wrote:
> > On Sun, May 03, 2009 at 03:43:28PM +0400, Andrey Borzenkov wrote:
> > > On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> > > > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov wrote:
> > > > > 01:00.0 VGA compatible controller: nVidia Corporation GeForce
> > > > > 8400M GS (rev a1)
> > > >
> > > > We don't know how to reinitialise nvidia graphics hardware.
> > >
> > > Just in case - same issue also after resume from hibernation. I was
> > > under impression, that hibernation does not have these issues as
> > > card goes via normal POST routine.
> >
> > Hm. That sounds a bit weirder.
> >
> 
> Is it worth further debugging? Anything I can provide?


Try it with minimum config, init=/bin/bash? Switch to plain vga
console?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
