Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYD3G0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYD3G0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbYD3G0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:26:07 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:48335 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbYD3G0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:26:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=lfRM/+vTdGaVQ88OnCKoww/VQ1oIx/+/DU26jWyr3ri4HBl+1/1sZE6rRx3UF
	jZeqszMHTm2UTQZo/BX8FCtWA==
Date: Wed, 30 Apr 2008 08:26:03 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tbm@cyrius.com
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
Message-ID: <20080430062603.GA14571@xi.wantstofly.org>
References: <20080429200853.GB20889@kos.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429200853.GB20889@kos.to>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:08:53PM +0300, Riku Voipio wrote:

> Thecus N2100 has leds and a buzzer attached to a pca9532
> controller. Attach the driver to the i2c bus and define
> the pca9532 pin coniguration for this platform in n2100_leds.
> 
> With this patch, support for N2100 should be complete in mainline
> Linux.
> 
> Signed-off-by: Riku Voipio <riku.voipio@iki.fi>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
