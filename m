Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbZCYOpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbZCYOpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZCYOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:45:28 -0400
Received: from flounder.pepperfish.net ([87.237.62.181]:35722 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbZCYOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:45:27 -0400
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 10:45:26 EDT
Subject: Re: [PATCH] GPIOLIB: Allow GPIOs to be named
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
In-Reply-To: <1236937429.1218.2.camel@petitemort>
References: <1231504690.8511.8.camel@petitemort>
	 <20090113131417.fe36d9bb.akpm@linux-foundation.org>
	 <1236256030.21294.4.camel@petitemort>  <1236937429.1218.2.camel@petitemort>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Wed, 25 Mar 2009 14:08:28 +0000
Message-Id: <1237990108.15128.11.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 09:43 +0000, Daniel Silverstone wrote:
> > David, have you had a chance to review this patch? It was also
> > added-to-mm on the 13th Jan as gpiolib-allow-gpios-to-be-named.patch --
> > I believe you were CCed on this add.
> > With -rc8 looming, I am anxious to know if this is acceptable for going
> > into the .30 merge window.
> Andrew,
> with -rc8 out, and David apparently MIA on this topic, is now an
> appropriate time for me to ask that you queue this up for the .30 merge
> window, or is that something you can't really do?

While I hate to nag, I thought I should ping on this again. Any movement
on whether or not this will go in?

Regards,

Daniel.

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


