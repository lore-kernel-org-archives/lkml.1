Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbXFDLGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbXFDLGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXFDLG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:06:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34746 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbXFDLG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:06:26 -0400
Date: Mon, 4 Jun 2007 13:06:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Seyfried <seife@suse.de>
Cc: Len Brown <lenb@kernel.org>, Chuck Ebbert <cebbert@redhat.com>,
       len.brown@intel.com, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070604110620.GM4363@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <20070517215203.GB7336@elf.ucw.cz> <200705171835.49176.lenb@kernel.org> <20070604090201.GA4802@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604090201.GA4802@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 11:02:01, Stefan Seyfried wrote:
> On Thu, May 17, 2007 at 06:35:48PM -0400, Len Brown wrote:
>  
> > Yes, SuSE enables polling mode by default, but that is just
> > distro specific "value add" that should eventually be fixed.
> 
> I will do that for openSUSE FACTORY.

Well, I still believe right solution is to enable polling mode as soon
as trip points are written (and ignoring bios updates from then
on). That gets trip point writing into functional state.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
