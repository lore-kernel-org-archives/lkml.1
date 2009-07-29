Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZG2LNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZG2LNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZG2LNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:13:55 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:50875 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZG2LNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:13:54 -0400
Date: Wed, 29 Jul 2009 12:13:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/32] mmc and omap_hsmmc patches
Message-ID: <20090729111327.GB6057@console-pimps.org>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 01:38:34PM +0300, Adrian Hunter wrote:
> Hi
> 
> Here is version 2 of our 32 patches for mmc and omap_hsmmc.
> 
> They include Matt Fleming's change for card caps, and 2 other fixes:
> 	- use a spin lock rather than enable / diable irq
> 	- make disable delay specified in milliseconds not jiffies because the
> 	value is an int, and jiffies are unsigned long (also millisecs are
> 	better anyway)
> 

Thanks for doing this Adrian. I appreciate it. My Reviewed-by tag still
applies.
