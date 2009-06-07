Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZFGXMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZFGXMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZFGXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:12:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZFGXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:12:29 -0400
Date: Sun, 7 Jun 2009 16:12:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
In-Reply-To: <200906071657.49513.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.01.0906071611290.6847@localhost.localdomain>
References: <200906071444.33047.bzolnier@gmail.com> <20090607152151.3cb01901@lxorguk.ukuu.org.uk> <1244385536.8262.5.camel@mulgrave.site> <200906071657.49513.bzolnier@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Jun 2009, Bartlomiej Zolnierkiewicz wrote:

> They don't export anything to user-space.

Bartlomiej, that's irrelevant. I want to release 2.6.30. We're not adding 
some totally new interfaces after -rc8.

This has nothing to do with user space or anything else. It's a new 
feature.

		Linus
