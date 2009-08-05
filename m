Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZHEXBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZHEXBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZHEXBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:01:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZHEXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:01:52 -0400
Date: Thu, 6 Aug 2009 01:01:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090805230147.GA15965@elf.ucw.cz>
References: <20090720103532.GD19341@elf.ucw.cz> <20090727153711.GA4323@kroah.com> <20090805152721.GA8337@elf.ucw.cz> <20090805160652.GA9474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805160652.GA9474@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Care to fix this up?
> > 
> > I'm afraid I don't quite have suitable config option. At least
> > synaptics touchpad should be usable outside dream.
> > 
> > OTOH Dream is still major user; and I guess I can just introduce
> > "CONFIG_DREAM". Should I?
> 
> What's wrong with using the CONFIG_ANDROID dependancy here?  Actually,
> why not use it for all of the dream files?

Well, my goal is to run Debian on Dream, so I do not need extensions
provided by CONFIG_ANDROID...

OTOH that is probably easiest and makes some sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
