Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYE2GRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYE2GRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYE2GRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:17:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:45363 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYE2GRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:17:32 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080528.225826.40264516.davem@davemloft.net>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 29 May 2008 16:17:19 +1000
Message-Id: <1212041839.8888.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 22:58 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 28 May 2008 12:20:12 -0500
> 
> > In the spirit of having a more process than technical based kernel
> > summit, I'd like to put the topic of the kernel Janitors project up for
> > discussion.
> 
> Not to distract from your points, but I think it's been a huge
> mistake to not allow folks to work hard on technical issues
> during the summit.

Having been stopped a couple of times last year when trying to bring
some technical subjects for the reason that they were "off topic, KS is
for process" I tend to agree :-)

There are some things that are hard to get through the list, or even
IRC, such as wanting to reorganize some part of the core and wanting to
get "live" input and discussion with most arch maintainers.

In my case it was some rework on some of the page table batching, for
which I finally didn't finish the work as I'm not too happy with what I
came up with, but I'm still somewhat convinced there's something to do
there and I could use a bit of a group beat-up in a room.

There are other areas like that which would benefit from that kind of
hard core tech discussion face to face.

However, on the other hand, KS is only 2 days, which doesn't leave room
for that much stuff. And I don't think splitting into sub-groups or
mini-summits is necessarily the answers. There are some areas where it's
useful to do the tech beatup -with- everybody in the room.

Just my 2 cents... Maybe we need 2 summits, the process one and the tech
one ? :-)

Cheers,
Ben.


