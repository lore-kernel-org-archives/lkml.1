Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXDKLbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXDKLbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXDKLbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:31:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45003 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXDKLbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:31:39 -0400
Message-ID: <461CC706.2010207@garzik.org>
Date: Wed, 11 Apr 2007 07:31:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Alpha update
References: <20070411122741.A17547@jurassic.park.msu.ru>
In-Reply-To: <20070411122741.A17547@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Assorted fixes and cleanups, including build fixes for recent toolchains,
> various platform-specific fixes and graphics support for non-zero PCI
> domains.
> 
> Thanks to Jay Estabrook for supplying most of these.

ACK, I'll try these out on a couple of my alphas too.

	Jeff



