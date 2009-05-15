Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZEOVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZEOVeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZEOVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbZEOVeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:34:05 -0400
Date: Fri, 15 May 2009 14:32:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
       davem@davemloft.net
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
In-Reply-To: <1242422710.3446.24.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905151432360.3343@localhost.localdomain>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>  <20090515182131.GA6439@fancy-poultry.org>  <20090515183319.GF2773@tuxdriver.com>  <alpine.LFD.2.01.0905151147520.3343@localhost.localdomain>
 <1242422710.3446.24.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 May 2009, Marcel Holtmann wrote:

> Hi Linus,
> 
> > > Unfortunately, I think Dave might have limited availability right now...
> > 
> > Yeah, I think he's on some Alaskan cruise.
> > 
> > Should I just pull directly from you this time?
> 
> I would have a similar pull request pending for Bluetooth fixes:
> 
> 	http://marc.info/?l=linux-netdev&m=124209765506433

Ok, I pulled that one too.

		Linus
