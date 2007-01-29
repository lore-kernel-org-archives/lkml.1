Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXA2Acb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXA2Acb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbXA2Acb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:32:31 -0500
Received: from waste.org ([66.93.16.53]:43428 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022AbXA2Aca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:32:30 -0500
Date: Sun, 28 Jan 2007 18:19:21 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eriberto <eriberto@eriberto.pro.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swap: which is the maximum size allowed?
Message-ID: <20070129001920.GC16722@waste.org>
References: <7IoP9-5nQ-27@gated-at.bofh.it> <E1HBIkM-0001I5-9q@be1.lrz> <epja0g$5fn$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <epja0g$5fn$1@sea.gmane.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 09:01:34PM -0200, Eriberto wrote:
> Ok. But, mkswap man is old (1999). However, from Linux Partition HOWTO:
> 
> "footnote: "official" max swap size: With kernel 2.4, the limit is 64
> swap spaces at a maximum of 64Gb each, although this is not reflected in
> the man page for mkswap. With the 64 bit opteron on the 2.6 kernel, 128
> swap areas are permitted, each a whopping 16 Tb! (thanks to Peter Chubb
> for the calculation)"
> 
> I want to know: why 64 GB???

It's how big the available pointers are.

-- 
Mathematics is the supreme nostalgia of our time.
