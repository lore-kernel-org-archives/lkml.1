Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866Ab0AOAQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab0AOAQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563Ab0AOAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:16:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45157 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0AOAQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:16:23 -0500
Date: Fri, 15 Jan 2010 00:16:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, InKi Dae <inki.dae@samsung.com>,
       Kyungmin Park <kmpark@infradead.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20100115001613.GA4241@sirena.org.uk>
References: <20100114102027.GC437@rakim.wolfsonmicro.main>
 <1263464783-14434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100114150658.643294f1.akpm@linux-foundation.org>
 <20100115000115.GA27344@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115000115.GA27344@opensource.wolfsonmicro.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2.6.33] s3c-fb: Fix divide by zero and broken output
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 12:01:16AM +0000, Mark Brown wrote:

> My understanding is that the breakage that was believed to exist was
> based on the driver misbehaving if you supply the pixclk as a frequency,
> which isn't surprising since that's what it's looking for.  The effect
                                     ^ not

obviously.
