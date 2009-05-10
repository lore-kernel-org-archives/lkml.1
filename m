Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZEKMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZEKMSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZEKMRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:17:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51557 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbZEKMRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:17:13 -0400
Date: Sun, 10 May 2009 07:38:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: trekker.dk@centrum.cz
Cc: tuxonice-devel@lists.tuxonice.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090510053840.GG1363@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905080037.19722@centrum.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-08 00:37:39, trekker.dk@centrum.cz wrote:
> Well...
> 
> >
> >
> >To summarise disadvantages:
> >
> >- only core has 8000 LoC
> >- it does stuff that can be easily done in userspace
> >     (and that todays distros _do_ in userspace).
> >- it duplicates uswsusp functionality.
> >- compared to [u]swsusp, it received little testing
> >
> 
> To summarise advatages - for me tuxonice is the only hibernation method that works.
> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
> 

Which kernels you tried, what hw it is? Can you do s2ram?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
