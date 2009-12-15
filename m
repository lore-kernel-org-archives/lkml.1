Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbZLOTLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbZLOTLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933350AbZLOTK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:10:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42512 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760907AbZLOTKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:10:48 -0500
Date: Tue, 15 Dec 2009 20:10:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Arve Hj?nnev?g <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215191040.GB26422@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <20091208224550.GA26915@n2100.arm.linux.org.uk>
 <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
 <20091209113739.GC22752@elf.ucw.cz>
 <1260375495.23633.175.camel@desktop>
 <20091213212918.GE5114@elf.ucw.cz>
 <1260812455.13078.3.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260812455.13078.3.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 09:40:55, Daniel Walker wrote:
> On Sun, 2009-12-13 at 22:29 +0100, Pavel Machek wrote:
> 
> > > I'm going to end up pulling a lot of these git commit into my git tree.
> > > It would be pretty easy for me to just pull this GPIO change directly ..
> > > I assume you haven't found a way to work with git that suites you? It
> > > would be best if you used git, but I could try to do some sort of quilt
> > > export if that works better for you.
> > 
> > I can easily "pull" git trees. I do my own work in git, but usually
> > not in a way that would be useful for pushing upstream (see my trees
> > at git.kernel.org). 
> > 
> > I *could* add my dream trees to those that are mirrored at kernel.org,
> > when things settle a bit. (Should I?)
> 
> I'm not sure I know what you mean .. What benefit would that have?

Very little benefit. Remote backup for me, chance to look into my
patches in progress for you. 

> > But I'd really prefer to push my stuff using plain old patches in
> > emails.
> 
> What I was meaning is you need to keep track of my tree via git, just so
> you know what's going into it and can work off it. If your already doing
> that, then no problem ..

Yes, I can pull easily, so all is well.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
