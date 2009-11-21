Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZKUPQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZKUPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZKUPQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:16:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKUPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:16:55 -0500
Date: Sat, 21 Nov 2009 15:16:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: walter harms <wharms@bfs.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
Message-ID: <20091121151647.GA13956@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de> <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 04:12:59PM +0100, Julia Lawall wrote:
> Both kzallocs were added at the same time, when the function was added in 
> commit 701a5dc05ad99a06958b3f97cb69d99b47cebee3.  I have added the author 
> to the CC list.

That commit id means nothing to me.
