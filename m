Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbXBVIbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbXBVIbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXBVIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:31:45 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:43932 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXBVIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:31:44 -0500
Date: Thu, 22 Feb 2007 09:32:04 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20070222083204.GN4641@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1056908425.20070221180037@gmail.com> <20070221161210.GL4641@enneenne.com> <1741775233.20070221182608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1741775233.20070221182608@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 06:26:08PM +0200, Paul Sokolovsky wrote:
k>   Why? It's the same, except that it already exists, generic one (not
> limited to pxafb), and requires 1 function (too bad that C doesn't
> support lambda's):

Ah, ok.

>   I sent a bit of criticism for that too ;-). YMMV, but kernel
> solutions are just bound to be pretty simple and generic and lack
> any "niceties", which you'd likely want to do anyway eventually. For
> example, what if you'll want to implement "fade out" effect for
> keyboard backlight? Doing it in adhoc manner in kernel? Whereas with
> the LCD classdev, you can write generic "fade out" trigger and
> attach/detach it from userspace.

I agree. I just wish to add a backlight support for my LCD and
minikeypad.

What do you suggest to me in order to accomplish such task?

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
