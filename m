Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbZC0A2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbZC0A2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbZC0A1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:27:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbZC0A1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:27:51 -0400
Date: Fri, 27 Mar 2009 01:30:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327003040.GH29836@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-27 11:15:28, James Morris wrote:
> On Thu, 26 Mar 2009, Pavel Machek wrote:
> 
> > Hi!
> > 
> > I don't think merging that is good idea.
> 
> It's already merged in Linus' tree.

Too bad.

> > Security should be doable
> > without making shell-like glob matching...
> 
> The TOMOYO developers have already responded to your feedback on this 
> issue.  It's also an inherent aspect of pathname security, an issue which 
> has been resolved in favour of inclusion in the kernel.

Do you have any references? My memory claims otherwise on this.

> As for the rest of the feedback, please work with the developers to fix 
> any bugs or lack of documentation.

Which brings a question: given that kernel<->user interface is
undocumented, how was this reviewed?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
