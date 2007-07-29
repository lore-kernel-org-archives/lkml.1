Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbXG2MKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbXG2MKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbXG2MKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:10:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbXG2MKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:10:24 -0400
Date: Sun, 29 Jul 2007 13:10:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: spyro@f2s.com, john@dnsworld.co.uk, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: RFC: Remove the arm26 port
Message-ID: <20070729121012.GA1375@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@stusta.de>, spyro@f2s.com, john@dnsworld.co.uk,
	linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
References: <20070707201208.GJ3492@stusta.de> <20070729115040.GD30976@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729115040.GD30976@stusta.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 01:50:40PM +0200, Adrian Bunk wrote:
> Considering the state of the arm26 port, I do hereby suggest to remove 
> it from the Linx kernel since it's far from a usable state and doesn't 
> seem to come back into a usable state.
> 
> If anyone wants to work on getting this port back into a usable state in 
> the forseeable future he should speak up now.

Yes, please.  This bitrotting code has been in the way for quite bit of
cross-architecture work I've been doing.

Btw, there's probably no point to Cc rmk as he's not involved with that
stinkin' pile.

