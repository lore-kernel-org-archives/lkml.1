Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbZGQN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbZGQN5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934659AbZGQN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:57:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43117 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934658AbZGQN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:57:51 -0400
Date: Fri, 17 Jul 2009 15:57:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream for staging
Message-ID: <20090717135743.GB19854@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz> <20090716230042.GB3609@kroah.com> <20090717010157.GA2002@elf.ucw.cz> <20090717011211.GA16704@kroah.com> <20090717120657.GB2192@elf.ucw.cz> <20090717134620.GB1315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717134620.GB1315@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-17 06:46:20, Greg KH wrote:
> On Fri, Jul 17, 2009 at 02:06:57PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > I guess I'm confused. I seem to recall that HTC Dream camera support
> > was marged into staging, but I can't see it in
> > http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=summary
> > . Is my memory wrong am I looking at wrong tree?
> 
> I never merged it.

Ok, I guessed so. I sent it as patch #4, patch #5 adds makefile glue
for all that. They should be all in your inbox now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
