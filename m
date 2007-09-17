Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXIQQSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXIQQSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXIQQSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:18:34 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54337 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbXIQQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:18:33 -0400
Date: Mon, 17 Sep 2007 18:18:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Schwartz <davids@webmaster.com>
Cc: "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917161845.GQ18232@stusta.de>
References: <20070917133845.GJ18232@stusta.de> <MDEHLPKNGKAHNMBLJOLKEEJGGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEJGGNAC.davids@webmaster.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 08:25:14AM -0700, David Schwartz wrote:
> 
> > And if you choose the GPL the code you distribute will be under the GPL 
> > *only* forever [1], so what value would be in shipping terms that are 
> > void?
> 
> Not true. You cannot chose the license that applies to other people's code. The code you distribute contains protectable elements from different authors. Each element is still offered under whatever license the original author offered it under.
> 
> You cannot affect the license grant from the author to the lawful possessor of code you did not author.
> 
> The code you *contribute* will be under the GPL *only* forever. But the code you distribute will contain elements from different authors offered under different licenses.
>...

The licence text we are talking about disagrees with what you claim:

<--  snip  -->

/*-
 * Copyright (c) 2002-2004 Sam Leffler, Errno Consulting
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer,
 *    without modification.
 * 2. Redistributions in binary form must reproduce at minimum a disclaimer
 *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
 *    redistribution must be conditioned upon including a substantially
 *    similar Disclaimer requirement for further binary redistribution.
 * 3. Neither the names of the above-listed copyright holders nor the names
 *    of any contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * Alternatively, this software may be distributed under the terms of the
 * GNU General Public License ("GPL") version 2 as published by the Free
 * Software Foundation.
 *
 * NO WARRANTY
 * ...

<--  snip  -->

We are talking about dual-licenced code, not about BSD licenced code 
incorporated into GPL'ed code.

That other people can distribute the original dual-licenced code 
dual-licenced or BSD-only, and that you can get the code under this 
licences from there, is without a doubt. But *the author* allowed me to 
choose the licence when *I distribute it*.

> DS

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

