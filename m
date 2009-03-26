Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZCZUMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZCZUMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZCZULy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:11:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZCZULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:11:53 -0400
Date: Thu, 26 Mar 2009 21:14:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next as a plain diff ?
Message-ID: <20090326201444.GA29836@elf.ucw.cz>
References: <20090326100555.GA21835@elf.ucw.cz> <alpine.LRH.2.00.0903261531000.8561@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903261531000.8561@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-26 15:33:06, Jiri Kosina wrote:
> On Thu, 26 Mar 2009, Pavel Machek wrote:
> 
> > Is there linux-next available somewhere as a plain diff? I'd like to 
> > look at tomoyo changes... unfortunately that does not seem exactly easy. 
> > I thought that maybe -mm could help, but... latest -mm listed on 
> > kernel.org is for 2.6.28-rc2-mm1....
> 
> You could either extract it trivially directly form -next git repository, 
> or get a (always little bit outdated) version from 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/linux-next.patch

Thanks! The last url is what I was looking for.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
