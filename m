Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0BNUvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:51:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0BNUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:51:39 -0500
Date: Sun, 14 Feb 2010 21:51:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214205117.GE2453@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
 <4B75A5DC.3060803@kernel.org>
 <20100212202357.6363d5af@hyperion.delvare>
 <20100212230702.GA10266@1wt.eu>
 <20100213091748.276821e1@hyperion.delvare>
 <4B767810.5020707@s5r6.in-berlin.de>
 <20100214171327.GF1578@ucw.cz>
 <4B7833FD.2010107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7833FD.2010107@s5r6.in-berlin.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-02-14 18:33:49, Stefan Richter wrote:
> Pavel Machek wrote:
> > On Sat 2010-02-13 10:59:44, Stefan Richter wrote:
> >> As a side note:  7zip, a very popular and Free archiving tool for
> >> Windows, supports xz since its version 9 which is currently available as
> >> a beta.  So, WRT the need to get an extra unarchiver, xz is just as
> >> accessible to Windows users as gz is.
> > 
> > Wow, what a stretch.
> > 
> > There's about milion tools supporting gz for Windows, and many of them
> > are out of beta...
> 
> And roughly half of this million archiving/ compression tools use 7zip's
> backend library, which is just one way of getting xz support in a
> Windows application.  Besides, what one project calls beta is called
> dot-zero release elsewhere. :-)  Seriously, getting xz support on
> Windows is just as easy or as difficult as getting gz support.

Sorry, but I just don't think that's true. No more windows systems
here. On android, gzip is supported, xzip is not. Debian machine
supports both, but gzip was preinstalled and I had to pull xzip. (This
does not help either:

root@amd:~# apt-cache search xzip
xzip - Interpreter of Infocom-format story-files

)									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
