Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZGBAet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZGBAet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZGBAek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:34:40 -0400
Received: from ozlabs.org ([203.10.76.45]:59335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZGBAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:34:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Date: Thu, 2 Jul 2009 10:04:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, tridge@samba.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021004.41907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 08:55:58 pm Alan Cox wrote:
> > I'd actually prefer to see the code ripped out and no config option
> > available; it would the clearest avoidance case possible.
>
> What about the free world - why should we suffer because Americans have
> a broken patent system ? That just leads to a Farenheit 451 model where
> the kernel sources end up containing no code, text or image that can
> offend, harm or be found wanting in any possible legal jurisdiction.

We put in workarounds for broken hardware, even though we rightfully dislike 
it.  Similarly, in this case a minor change prevents a real problem 
experienced by our users (yes, I know we only have one public bug report).

It's bad.  Yes, let's bitch about it.  And workaround it anyway.
Rusty.
