Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXEUNlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXEUNlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEUNk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:40:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43126 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755740AbXEUNkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:40:55 -0400
Date: Mon, 21 May 2007 15:40:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070521134046.GE8332@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <1179604609.16465.83.camel@sublime.suse.de> <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521133608.GB7540@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-05-21 14:36:08, Matthew Garrett wrote:
> On Mon, May 21, 2007 at 03:29:48PM +0200, Pavel Machek wrote:
> > > > No. Manually turning off fans is even worse hack.
> > > 
> > > It's significantly more correct.
> > 
> > Significantly more correct? It forces you to do all the thermal
> > management in userspace!
> 
> Why's that a problem? 

Duplicating all the kernel logic in userspace, badly?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
