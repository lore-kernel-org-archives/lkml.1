Return-Path: <linux-kernel-owner+w=401wt.eu-S2993017AbXCIGpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993017AbXCIGpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993016AbXCIGpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:45:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:29879 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993014AbXCIGpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:45:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,265,1170662400"; 
   d="scan'208"; a="192939735:sNHT17507273"
Message-ID: <45F10274.7070500@intel.com>
Date: Thu, 08 Mar 2007 22:45:08 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: peter.p.waskiewicz.jr@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, christopher.leech@intel.com
Subject: Re: [PATCH 0/2] NET: Multiple queue network device support REPOST
References: <1173420779298-git-send-email-peter.p.waskiewicz.jr@intel.com> <20070308.222154.74746753.davem@davemloft.net>
In-Reply-To: <20070308.222154.74746753.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> You didn't address my correction the other day wherein I clarified
> for you that my idea was not to store the queue mapping in
> skb->priority but rather to shrink skb->priority to a u16 and
> add a new u16 skb->queue_mapping or whatever field to store the
> necessary information.
> 
> You're just posting a set of patches using the same approach again
> plus some bug fixes, so there is essentially nothing new for anyone to
> review.
> 
> Why ask for feedback if you fail to take any of it into consideration?
> :-/

Where are the patches anyway? They didn't seem to make it either to netdev nor lkml!

Auke
