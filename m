Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYD2U6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYD2U6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbYD2U5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:57:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49008 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763295AbYD2U5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:57:20 -0400
Date: Tue, 29 Apr 2008 21:56:59 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, buytenh@wantstofly.org, tbm@cyrius.com
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
Message-ID: <20080429205659.GC31311@flint.arm.linux.org.uk>
References: <20080429200853.GB20889@kos.to> <20080429132631.e0dc7803.akpm@linux-foundation.org> <20080429204649.GA23817@kos.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429204649.GA23817@kos.to>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:46:49PM +0300, Riku Voipio wrote:
> Since it depends on pca9532-led-driver being added first, I believe
> it would logistically simpler to get both patches through leds tree.

Yes it does, and given that it should go along side the other patch
in the same tree.  Otherwise we _are_ going to cause compilation
damage.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
