Return-Path: <linux-kernel-owner+w=401wt.eu-S1946216AbXEAAYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946216AbXEAAYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946213AbXEAAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:24:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44163 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946216AbXEAAYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:24:15 -0400
Message-ID: <463688AD.1050903@garzik.org>
Date: Mon, 30 Apr 2007 20:24:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: to something appropriate (was Re: 2.6.22 -mm merge plans)
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	<46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org>
In-Reply-To: <20070430170919.45e4b42b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yeah, a new-id patch is a pretty critical bugfix if you happen to have that
> hardware.  I'll get all these into 2.6.22 by whatever means and will adopt
> your advice in future.
> 
> Probably these should go into -stable too, but I don't know what
> Greg&Chris's position is on new device IDs.

I don't know either.  But a one-line ID patch is pretty painless 
considering the gain, so I would vote for stable@kernel.org taking such 
patches.

If it's more than one line added per ID though, NAK for -stable, IMO...

	Jeff


