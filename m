Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbXGAOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbXGAOz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 10:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXGAOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 10:55:18 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:46545 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXGAOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 10:55:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=lI7/aavRdtCzrkBmSghjGm4MJdmJhAZgsfiwEf4r0A+yLHVsiY0PK4mMcM1Um
	7UpZelX6vr71Nc4Xr+bb38blQ==
Date: Sun, 1 Jul 2007 16:55:14 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PXA27x UDC driver.
Message-ID: <20070701145514.GD7929@xi.wantstofly.org>
References: <20070628103619.GW13886@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628103619.GW13886@enneenne.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 12:36:20PM +0200, Rodolfo Giometti wrote:

> attached you can find new version of my patch for PXA27x UDC driver
> support against kernel 2.6.22-rc3 (but it applies also ro rc6).
> 
> I'd like to know what I have to do in order to prepare this patch for
> kernel inclusion. It's time PXA27x has its UDC driver into linux! :)

Aren't there about 300 different versions of the PXA27x gadget
driver out there?
