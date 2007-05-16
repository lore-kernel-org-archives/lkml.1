Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbXEPK4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbXEPK4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXEPK4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:56:31 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:33553 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbXEPK4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:56:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=OFhTnwaM0CGDF9qB0G5VXfzaPR2sa1udPe/P+U73E3M3kJ9a7+Z4NG1dxeO/v
	LKDTMohOS2Z0amvVmfLCoiKVg==
Date: Wed, 16 May 2007 12:56:26 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rod Whitby <rod@whitby.id.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       Michael Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Message-ID: <20070516105626.GC16262@xi.wantstofly.org>
References: <464034CF.20700@wpkg.org> <20070516071300.GB14222@infradead.org> <20070516094100.GB16262@xi.wantstofly.org> <464AE10E.7090606@whitby.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464AE10E.7090606@whitby.id.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:16:38PM +0930, Rod Whitby wrote:

> So, if the author of these patches wishes to concentrate on big-endian
> support first, then we will not say (and have not said) anything which
> will block inclusion of a big-endian only version of this driver.

The NSLU2 people are the ones here that are saying that the driver
should really support LE (because that is what they happen to be
using, the rest of the world runs the ixp4xx in BE), and they keep
saying that it would be so easy to make a patch to add LE support,
but so far they haven't produced such a patch.

Please just write the patch and let's get this over with.
