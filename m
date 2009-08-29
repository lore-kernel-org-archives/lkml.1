Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZH2Veh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZH2Veh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 17:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZH2Veg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 17:34:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44249 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZH2Vef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 17:34:35 -0400
Date: Sat, 29 Aug 2009 23:33:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090829213352.GB1375@ucw.cz>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <1251362787.4354.373.camel@macbook.infradead.org> <alpine.DEB.2.00.0908280738140.6822@asgard.lang.hm> <20090829100909.GI1634@ucw.cz> <alpine.DEB.2.00.0908290923130.6822@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908290923130.6822@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> This is really so easy to reproduce, that such speedup is not
>> neccessary. Just try the scripts :-).
>
> so if it doesn't get corrupted after 5 unplugs does that mean that that  
> particular device doesn't have a problem? or does it just mean you got  
> lucky?
>
> would 10 sucessful unplugs mean that it's safe?
>
> what about 20?

I'd say 20 means its safe.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
