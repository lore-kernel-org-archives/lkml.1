Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbZIDHo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbZIDHo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932784AbZIDHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:44:56 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34961
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbZIDHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:44:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: jim owens <jowens@hp.com>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Fri, 4 Sep 2009 02:44:53 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com>
In-Reply-To: <4A9FCF53.10105@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909040244.54772.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 09:14:43 jim owens wrote:
> Rob Landley wrote:
> > I think he understands he was clueless too, that's why he investigated
> > the failure and wrote it up for posterity.
> >
> >> And Ric said do not stigmatize whole classes of A) devices, B) raid,
> >> and C) filesystems with "Pavel says...".
> >
> > I don't care what "Pavel says", so you can leave the ad hominem at the
> > door, thanks.
>
> See, this is exactly the problem we have with all the proposed
> documentation.  The reader (you) did not get what the writer (me)
> was trying to say.  That does not say either of us was wrong in
> what we thought was meant, simply that we did not communicate.

That's why I've mostly stopped bothering with this thread.  I could respond to 
Ric Wheeler's latest (what does write barriers have to do with whether or not 
a multi-sector stripe is guaranteed to be atomically updated during a panic or 
power failure?) but there's just no point.

The LWN article on the topic is out, and incomplete as it is I expect it's the 
best documentation anybody will actually _read_.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
