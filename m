Return-Path: <linux-kernel-owner+w=401wt.eu-S965828AbXDBUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbXDBUUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965824AbXDBUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:20:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965822AbXDBUUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:20:04 -0400
Message-ID: <46116570.3050109@redhat.com>
Date: Mon, 02 Apr 2007 16:20:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christian Kujau <evil@g-house.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
In-Reply-To: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> 
> Please see http://nerdbynature.de/bits/2.6.20.4/ for details for both
> hosts and feel free to ask for more details. Although both boxes are in
> production we'll be happy test more bootoptions/patches and the like.

Where is the info from before you changed to "noapic"? Or were the
machines always using XT-PIC for all the interrupts???

