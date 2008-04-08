Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYDHJkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYDHJkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYDHJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:40:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44044
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbYDHJkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:40:41 -0400
Date: Tue, 08 Apr 2008 02:40:41 -0700 (PDT)
Message-Id: <20080408.024041.190167032.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rjw@sisk.pl, robbat2@gentoo.org,
       gf@unixsol.org, kernel@nn7.de, denys@visp.net.lb,
       alessandro.suardi@gmail.com
Subject: Re: [PATCHv2 net-2.6 0/4 (was 0/3)]: TCP fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0804080050060.20948@wrl-59.cs.helsinki.fi>
References: <1207569344-19687-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<Pine.LNX.4.64.0804080050060.20948@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Tue, 8 Apr 2008 00:59:45 +0300 (EEST)

> On Mon, 7 Apr 2008, Ilpo Järvinen wrote:
> 
> > Ok, here's the v2 series 
> 
> [...snip...]
> 
> > ...So far, they're just compile tested. I'll see if I find some time
> > to boot them on the evening.
> 
> $ uptime
>  00:53:23 up  1:20,  6 users,  load average: 0.54, 0.22, 0.13
> 
> ...some torrent & browsing, mainly with tso & tcp_sack = 0. Didn't hit 
> any problems with it (I had my debug patch in as well).

I've applied all four patches to net-2.6 and will push them
to Linus when I get a chance.

Thanks!
