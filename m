Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbYF2UBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbYF2UBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbYF2UBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:01:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360AbYF2UBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:01:02 -0400
Date: Sun, 29 Jun 2008 16:01:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drivers for selfmade hardware
Message-ID: <20080629200101.GA29452@infradead.org>
References: <200806292147.52112.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806292147.52112.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 09:47:52PM +0200, Michael Buesch wrote:
> I'm wondering what the policy is for selfmade hardware
> or other hardware where only a few pieces exist. Is it desired
> to get drivers for this kind of hardware merged upstream into the
> mainline kernel?
> 
> I have a tiny driver that can be used to drive a modified
> Brooktree 8xx based card in 24-port GPIO mode.
> So the card can be used as a cheap digital PCI GPIO card.
> This hardware can be built with some soldering skills, a tiny
> soldering tip and a few hours of free time.
> 
> So what's the policy? Push to mainline or keep as seperate

Push to mainline as long as you have a nice enough guide on the web
somewhere describing how to build it :)

