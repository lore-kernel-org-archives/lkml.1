Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYD2VRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYD2VRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYD2VRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:17:06 -0400
Received: from tim.rpsys.net ([194.106.48.114]:49788 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYD2VRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:17:03 -0400
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
From: Richard Purdie <rpurdie@rpsys.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Riku Voipio <riku.voipio@iki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       buytenh@wantstofly.org, tbm@cyrius.com
In-Reply-To: <20080429205659.GC31311@flint.arm.linux.org.uk>
References: <20080429200853.GB20889@kos.to>
	 <20080429132631.e0dc7803.akpm@linux-foundation.org>
	 <20080429204649.GA23817@kos.to>
	 <20080429205659.GC31311@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 22:16:14 +0100
Message-Id: <1209503774.5642.54.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 21:56 +0100, Russell King wrote:
> On Tue, Apr 29, 2008 at 11:46:49PM +0300, Riku Voipio wrote:
> > Since it depends on pca9532-led-driver being added first, I believe
> > it would logistically simpler to get both patches through leds tree.
> 
> Yes it does, and given that it should go along side the other patch
> in the same tree.  Otherwise we _are_ going to cause compilation
> damage.

Agreed, I'll take them in the LED tree then after I've had a closer look
at the driver tomorrow.

The LED tree has already merged for this development cycle though so it
will have to be queued for the next one.

Cheers,

Richard


