Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYEFHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYEFHbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYEFHbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:31:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYEFHbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:31:45 -0400
Date: Tue, 6 May 2008 09:32:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: driver now down to 16Kloc, and actually works a bit
Message-ID: <20080506073232.GB4600@elf.ucw.cz>
References: <20080505210138.GE7273@elf.ucw.cz> <1210021369.4181.43.camel@johannes.berg> <1210023090.8012.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210023090.8012.2.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Ok, code is still extremely ugly, but at least it uses softmac (and
> > 
> > why not mac80211? softmac has been deleted
> 
> Never mind, a peek inside tells me it does use mac80211.
> 
> However, the code gives me the creeps so I won't look any further.

Sorry about the creeps. I'll be sure to do big announcement when it is
safe to look at ;-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
