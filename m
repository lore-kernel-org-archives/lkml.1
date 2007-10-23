Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXJWRDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXJWRDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbXJWRD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:03:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbXJWRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:03:26 -0400
Date: Tue, 23 Oct 2007 10:00:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emil Medve <Emilian.Medve@Freescale.com>
cc: axboe@kernel.dk, paulus@samba.org, chris@zankel.net,
       grundler@parisc-linux.org, kyle@parisc-linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ashok.raj@intel.com,
       shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       parisc-linux@lists.parisc-linux.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the new sg_page() helper
In-Reply-To: <1193156092-11819-1-git-send-email-Emilian.Medve@Freescale.com>
Message-ID: <alpine.LFD.0.999.0710230956330.30120@woody.linux-foundation.org>
References: <1193156092-11819-1-git-send-email-Emilian.Medve@Freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Emil Medve wrote:
>
> Fix build error messages such as this:

Some - but apparently not all - of these are already fixed in my tree, 
through pulls from Jens. I just pushed out the result, can you resend the 
parts that didn't already get fixed?

As is, the patch won't apply for me, since it touches many different parts 
and some of them are fixed.

		Linus
