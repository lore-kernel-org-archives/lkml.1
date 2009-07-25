Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZGYUQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZGYUQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZGYUQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:16:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbZGYUQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:16:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Regression] kdesu broken
Date: Sat, 25 Jul 2009 22:16:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
References: <200907240145.31935.rjw@sisk.pl> <20090725124859.530d158b@lxorguk.ukuu.org.uk> <200907251602.49918.elendil@planet.nl>
In-Reply-To: <200907251602.49918.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252216.42889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Frans Pop wrote:
> Alan Cox wrote:
> > Linus Torvalds wrote:
> >> We don't do regressions. If user space depended on old behavior, we
> >> don't change behavior
> > 
> > I think there are two bugs being confused here. The first kdesu bug
> > isn't the EIO one. It's just busted userspace code that happened to be
> > lucky. 
> > It's also impossible to keep that "luck" going. The other problem is the
> > EIO - which is a bug.
>  
> Just out of curiosity ad for reference.
> Has this issue already been reported to the KDE people? Any links to a bug 
> report or discussions there?

Not that I know of.  It's probably worth reporting, though.

Best,
Rafael
