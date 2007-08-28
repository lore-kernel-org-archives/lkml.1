Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXH1NOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXH1NOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXH1NOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:14:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43552 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXH1NOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:14:01 -0400
Date: Tue, 28 Aug 2007 15:14:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Evans <mjevans1983@gmail.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
In-Reply-To: <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708281511470.3018@fbirervta.pbzchgretzou.qr>
References: <200708222058.45480.mjevans1983@comcast.net> 
 <200708271516.21889.mjevans1983@comcast.net>  <20070827153020.43788e21.randy.dunlap@oracle.com>
  <200708272138.19785.mjevans1983@comcast.net>  <46D3A8AD.6000701@oracle.com>
 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 06:08, Michael Evans wrote:
>
>Oh, I see.  I forgot about the changelogs.  I'd send out version 5
>now, but I'm not sure what kernel version to make the patch against.
>2.6.23-rc4 is on kernel.org and I don't see any git snapshots.

2.6.23-rc4 is a snapshot in itself, a tagged one at that.
Just use git pull to get the latest, which is always good.
Or git fetch; git checkout 2.6.23-rc4; if you need that particular one.

>Additionally I never could tell what git tree was the 'mainline' as it
>isn't labeled with such a keyword (at least in the list of git trees I
>saw).

/torvalds/linux-2.6.git or so; yes, it's not clearly marked. Then again, why?
/Mainline is tarballs for most people, and they don't want to go deeper ;-)


	Jan
-- 
