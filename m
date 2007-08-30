Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXH3Nn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXH3Nn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXH3Nnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:43:47 -0400
Received: from mx2.go2.pl ([193.17.41.42]:38691 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754057AbXH3Nnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:43:45 -0400
Date: Thu, 30 Aug 2007 15:45:06 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, Xavier Bestel <xavier.bestel@free.fr>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Message-ID: <20070830134506.GB2778@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829204529.66ce1bcb@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-08-2007 13:59, Johannes Berg wrote:
> On Wed, 2007-08-29 at 15:13 +0200, Xavier Bestel wrote:
> 
>> How about asking for changes to be dual-licenced too ?
> 
> In theory, that could work, but in practice relying on functions that
> the Linux kernel offers in GPLv2-only headers etc. will make the result
> GPLv2 anyway, and disentangling it would be a nightmare.
> 

Why?

Very good point, but, in my opinion, it should be still resonable for
both sides: it simply means such changes are mostly unusable for the
other side, but nobody is going to waste time for marking all these
places, or care about suing if accidentally the changes, after some
adaptation, are usable for the other side. Unless you think or know
that "#include xyz" or "print_linux_way()" should add more than these
(maybe unusable) words or lines only?

Jarek P.
