Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZIEV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZIEV1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZIEV1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:27:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZIEV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:27:34 -0400
Date: Sat, 5 Sep 2009 23:27:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
       jim owens <jowens@hp.com>, david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090905212732.GB27650@elf.ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com> <200909040244.54772.rob@landley.net> <4AA0FECE.3010200@redhat.com> <20090905102810.GA1341@ucw.cz> <20090905075424.4e103612@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090905075424.4e103612@bike.lwn.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-05 07:54:24, Jonathan Corbet wrote:
> On Sat, 5 Sep 2009 12:28:10 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > >> The LWN article on the topic is out, and incomplete as it is I expect it's the
> > >> best documentation anybody will actually _read_.  
> > 
> > Would anyone (probably privately?) share the lwn link?
> 
> 	http://lwn.net/SubscriberLink/349970/9875eff987190551/
> 
> assuming you've not already gotten one from elsewhere.

Thanks, and thanks for nice article!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
