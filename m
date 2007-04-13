Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbXDMCps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbXDMCps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXDMCpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:45:47 -0400
Received: from [69.90.0.18] ([69.90.0.18]:38111 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXDMCpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:45:47 -0400
Date: Thu, 12 Apr 2007 22:45:44 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Roland Dreier <rdreier@cisco.com>
cc: Benny Amorsen <benny+usenet@amorsen.dk>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <adabqhtip2n.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0704122243280.9866@mtl.rackplans.net>
References: <1175644642.10567.31.camel@shinybook.infradead.org>
 <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org>
 <20070403.181645.68159458.davem@davemloft.net> <20070404022828.5c9b97f3@the-village.bc.nu>
 <Pine.LNX.4.64.0704032307001.7802@mtl.rackplans.net> <m3tzvm6fgw.fsf@ursa.amorsen.dk>
 <adabqhtip2n.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it's not the speed it's the cost.. The best I've ever done is 
5.5 interfaces per u/ Although with a better motherboard and case it might 
have been different.

http://innerfire.net/pics/projects/21portfirewall_2.jpg
(assigns each port it's ip range and blocks any address not assigned to 
that port)


On Thu, 12 Apr 2007, Roland Dreier wrote:

> Date: Thu, 12 Apr 2007 08:34:40 -0700
> From: Roland Dreier <rdreier@cisco.com>
> To: Benny Amorsen <benny+usenet@amorsen.dk>
> Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
> 
>  > Indeed, port density is disappointingly poor in modern servers. Do you
>  > know any with more than 14 ports per U? (That's an MBX 1U server with
>  > 8 on-board and a 6-port expansion).
> 
> If you really need a ton of ports you could probably build a 1U server
> with 2 * 2-port 10gig NICs, and use VLAN-capable switches with 10gig
> and 1gig ports to fan out each 10gig link from your server to 10 1-gig
> ports.  That would get you 40 ports of 1-gig from each server (plus
> whatever the server has on board).
> 
>  - R.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
