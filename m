Return-Path: <linux-kernel-owner+w=401wt.eu-S1763706AbZAPKna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763706AbZAPKna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZAPKnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:43:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53007 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756127AbZAPKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:43:09 -0500
Date: Fri, 16 Jan 2009 10:43:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: sedji.gaouaou@atmel.com, linux-kernel <linux-kernel@vger.kernel.org>,
       tiwai@suse.de
Subject: Re: [PATCH] atmel_pcm: Remove non-existant header
Message-ID: <20090116104306.GA14832@rakim.wolfsonmicro.main>
References: <1232055945.2714.160.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232055945.2714.160.camel@linux-51e8.site>
X-Cookie: This space intentionally left blank.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 08:45:45AM +1100, Ben Nizette wrote:

> <mach/hardware.h> doesn't exist on AVR32 and therefore this driver won't
> build on that arch.  AFAICT this driver doesn't actually use the content
> of that header so easiest just to remove it.

> Signed-off-by: Ben Nizette <bn@niasdigital.com>

Build tested on AT91 and applied, thanks.
