Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZICJJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZICJJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZICJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:08:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47728 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZICJI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:08:58 -0400
Date: Thu, 3 Sep 2009 11:08:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] Update Documentation/md.txt to mention journaling
	won't help dirty+degraded case.
Message-ID: <20090903090839.GF3793@elf.ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz> <200909021749.47695.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909021749.47695.rob@landley.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-02 17:49:46, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Add more warnings to the "Boot time assembly of degraded/dirty arrays" section,
> explaining that using a journaling filesystem can't overcome this problem.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

I like it! Not sure if I know enough about MD to add ack, but...

Acked-by: Pavel Machek <pavel@ucw.cz>

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
