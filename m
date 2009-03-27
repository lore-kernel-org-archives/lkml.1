Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZC0Lek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZC0Lek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZC0LeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:34:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZC0LeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:34:10 -0400
Date: Fri, 27 Mar 2009 12:36:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327113645.GC2585@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <20090327003040.GH29836@elf.ucw.cz> <alpine.LRH.2.00.0903271146560.11179@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903271146560.11179@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > As for the rest of the feedback, please work with the developers to fix 
> > > any bugs or lack of documentation.
> > 
> > Which brings a question: given that kernel<->user interface is
> > undocumented, how was this reviewed?
> 
> By 15 iterative posts to lkml and LSM, with extensive discussion and 
> feedback, as well as presentations by the TOMOYO developers at various 
> conferences around the world.

Yeah, 15 posts to lkml, largely ignored becuase the design problems
seemed unfixable...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
