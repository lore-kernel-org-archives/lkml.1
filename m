Return-Path: <linux-kernel-owner+w=401wt.eu-S1764535AbXGNBXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764535AbXGNBXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbXGNBX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:23:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60676 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760283AbXGNBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:23:27 -0400
Date: Sat, 14 Jul 2007 03:23:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland McGrath <roland@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Use --build-id ld option
Message-ID: <20070714012301.GB3565@stusta.de>
References: <4695B28E.2020603@goop.org> <20070712062458.6B2BD4D0489@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070712062458.6B2BD4D0489@magilla.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:24:58PM -0700, Roland McGrath wrote:
> > Does this mean that performing the same link twice *will* produce an 
> > identical result?
> 
> Yes.

But note that twice compiling a kernel with the same .config will result 
in a different one.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

