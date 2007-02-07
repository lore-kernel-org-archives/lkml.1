Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXBGLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXBGLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161215AbXBGLVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:21:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4073 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161198AbXBGLVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:21:30 -0500
Date: Wed, 7 Feb 2007 11:21:21 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christian Axelsson <smiler@lanil.mine.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [swsusp] s2ram fails to restore graphics
Message-ID: <20070207112120.GA4481@ucw.cz>
References: <45C8B688.1080105@lanil.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C8B688.1080105@lanil.mine.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm having problems with s2ram being unable to restore 
> my Intel 945GM (a Dell D420 laptop) when resuming. I 
> think everything else is restored properly (I have input 
> so I can reboot or suspend again). Full hibernation is 
> working flawless on this machine including restoring 
> framebuffer and X (kudos to the suspend team :).

> I've tried both with and without framebuffer on 2.6.20.
> Using the vbetool-trick brings the backlight on (it's 
> otherwise off after resume).

Use latest s2ram from suspend.sf.net...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
