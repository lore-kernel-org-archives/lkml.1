Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXHPUp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXHPUp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXHPUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:45:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3174 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbXHPUpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:45:18 -0400
Subject: Re: [PATCH] [540/2many] MAINTAINERS - WATCHDOG DEVICE DRIVERS
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070816203034.GA4495@infomag.infomag.iguana.be>
References: <46bffcab.hvODrZFyIOzH/Lb/%joe@perches.com>
	 <20070816194638.GA3498@infomag.infomag.iguana.be>
	 <20070816203034.GA4495@infomag.infomag.iguana.be>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 13:44:37 -0700
Message-Id: <1187297077.5906.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 22:30 +0200, Wim Van Sebroeck wrote:
> Patch removed until there is a consensus on how to proceed with your proposal.

Hi Wim.

I think that's wise.

I've got all the changes that people have CC'd me.
I expect it'll be an all or nothing sort of thing.

Even if it's nothing, the content tracking parts
might be useful if another of the proposals floating
'round gets implemented.

I personally find the distributed MAINTAINERS approach
a bit odd given that there isn't really a single place
for many of the parts of a maintained block to be.

The single MAINTAINERS is too "hot" to use Linus' word.
I rather like the Maintainers/* block approach myself.

Unless that's rejected out of hand, that's what I'll
submit tomorrow.

cheers,  Joe

