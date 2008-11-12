Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYKLKlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYKLKlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYKLKln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:41:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60968 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750843AbYKLKlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:41:42 -0500
Date: Wed, 12 Nov 2008 11:41:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: regression, thinkpad x60 will not reboot
Message-ID: <20081112104129.GA11945@ucw.cz>
References: <20081109123335.GA1783@elf.ucw.cz> <200811091426.24888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811091426.24888.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-09 14:26:24, Rafael J. Wysocki wrote:
> On Sunday, 9 of November 2008, Pavel Machek wrote:
> > Hi!
> > 
> > Subject says it pretty much all. No, I do not think I have KVM
> > enabled:
> > 
> > CONFIG_HAVE_KVM=y
> > 
> > ...is the only KVM related option in my .config.
> > 
> > It seems 100% reproducible.
> 
> Can you check if
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d00450d296dedec9ada38d43b83e79cca6fd5a3
> helps, please?

It seems fixed now, thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
