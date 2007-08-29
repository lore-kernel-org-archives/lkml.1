Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXH3Var@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXH3Var (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXH3Vak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:30:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38906 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbXH3Vaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:30:39 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 17:30:39 EDT
Date: Wed, 29 Aug 2007 18:50:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: resume failing on ATA controller
Message-ID: <20070829185047.GA3031@toy.ucw.cz>
References: <21d7e9970708270129u2a619b8dx79fbdaddc55fa16f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970708270129u2a619b8dx79fbdaddc55fa16f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> I've got an HP 2510p with a 965 mobile chipset and ICH8, lspci is at
> 
> http://people.freedesktop.org/~airlied/hp2510p/hp-lspci-vv.txt
> 
> Resume is failing on the hard disk resume by the looks of it (no video
> to prove it..) but I've rmmod nearly everything and my network
> interface comes back and I can ping it but anything that tries to
> access the disk looks stuck...
> 
> I also know someone running the same laptop using drivers/ide drivers
> whose suspend/resume works properly....

Do you use power-on password by chance?

> I'm running the latest Fedora rawhide kernel based on -rc3-git7

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
