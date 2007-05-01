Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXEAAqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXEAAqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXEAAqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:46:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44264 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXEAAqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:46:02 -0400
Message-ID: <46368DA5.7070003@garzik.org>
Date: Mon, 30 Apr 2007 20:45:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge plans)
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org>
In-Reply-To: <20070501004036.GS2819@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> 2) you can add them
> runtime in userspace (and for pcmcia too after patch in question is
> applied), so we've historically avoided that kind of patch for -stable.


Due to distro installer environments, and very poor support for making 
dynamic PCI IDs persistent once added, what you describe is more of a 
goal than reality.

	Jeff


