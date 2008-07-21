Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYGULq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYGULq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYGULqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:46:46 -0400
Received: from namei.org ([69.55.235.186]:49634 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751590AbYGULqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:46:45 -0400
Date: Mon, 21 Jul 2008 21:45:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Patrick McHardy <kaber@trash.net>
cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <4883E465.4050405@trash.net>
Message-ID: <Xine.LNX.4.64.0807212143540.17349@us.intercode.com.au>
References: <20080720.104411.81744468.davem@davemloft.net>
 <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
 <20080720.180304.51601407.davem@davemloft.net> <4883E465.4050405@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Patrick McHardy wrote:

> > James/Patrick please fix this.
> >   
> 
> This is only the NETFILTER_ADVANCED=n default (for SECURITY=y).
> The netfilter defaults for NETFILTER_ADVANCED=n should be m/y for
> things that are needed by mainstream distributions for normal
> usage.
> 
> I'm not sure how this is going to be used, James?

I think the idea now is that everything new is N by default, but the 
intention is to have this enabled in Fedora/RHEL.

Patrick, would you please fix this up?  The only dev box I have access to 
at the moment doesn't boot with recent git (I think it's the macbook2 
issue).


- James
-- 
James Morris
<jmorris@namei.org>
