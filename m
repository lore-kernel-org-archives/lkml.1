Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYFYBMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYFYBMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYFYBMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:12:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699AbYFYBMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:12:23 -0400
Date: Tue, 24 Jun 2008 18:12:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 2.6.26-rc7
In-Reply-To: <48616182.9030902@qumranet.com>
Message-ID: <alpine.LFD.1.10.0806241809530.17712@woody.linux-foundation.org>
References: <48616182.9030902@qumranet.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, Avi Kivity wrote:
>
> Linus, please pull from the repo and branch at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.26
> 
> to receive kvm updates for 2.6.26-rc7.  The patches fix host oopses,
> guest interrupt loss, and total kvm clock borkage.

Avi, you _really_ need to start respecting the merge window.

If you can't learn, I will have to just stop pulling from you. This is 
simply too big for this late in the game.

I pulled, but I'm simply not going to continue doing this dance. I don't 
care much for virtualization, so I've let it slide, but you need to learn 
that 

> 18 files changed, 358 insertions(+), 266 deletions(-)

is simply not acceptable this late. 

			Linus
