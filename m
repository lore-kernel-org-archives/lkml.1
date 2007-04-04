Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXDDDHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXDDDHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992557AbXDDDHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:07:41 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:42034 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992554AbXDDDHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:07:40 -0400
Date: Tue, 3 Apr 2007 23:07:38 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070404022828.5c9b97f3@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0704032307001.7802@mtl.rackplans.net>
References: <1175644642.10567.31.camel@shinybook.infradead.org>
 <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org>
 <20070403.181645.68159458.davem@davemloft.net> <20070404022828.5c9b97f3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Alan Cox wrote:
> You don't get machines with 64 ethernet ports on add-in cards. There are
> good reasons for the naming schemes in use.

If they made them I'd build one.

http://innerfire.net/pics/projects/21portfirewall_2.jpg

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
