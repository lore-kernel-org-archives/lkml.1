Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbXJDKIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbXJDKIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXJDKIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:08:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58631 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755766AbXJDKIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:08:37 -0400
Date: Thu, 4 Oct 2007 12:06:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org, bwalle@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: kdump: documentation cleanups
Message-ID: <20071004100652.GH22940@elf.ucw.cz>
References: <20071004094206.GA564@elf.ucw.cz> <Pine.LNX.4.64.0710040602510.11078@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710040602510.11078@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-10-04 06:04:09, Robert P. J. Day wrote:
> On Thu, 4 Oct 2007, Pavel Machek wrote:
> 
> > -On powererpc systems when a soft-reset is generated, die() is called by all cpus
> > +On powerpc systems when a soft-reset is generated, die() is called by all cpus
>                                                                              ^^^
> 
>   i thought the recent standard was to use the capitalized form of
> "CPU".

But that is something for separate patch :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
