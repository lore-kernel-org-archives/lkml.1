Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbXJRECu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbXJRECu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXJRECm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:02:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbXJRECl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:02:41 -0400
Date: Wed, 17 Oct 2007 21:01:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <4716D6B1.8010309@rtr.ca>
Message-ID: <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
 <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
 <4716D6B1.8010309@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Mark Lord wrote:
> 
> It would be good to have something soon-ish.
> This "dead at boot time" issue is impacting the general ability to test
> patches against latest -git in time for the current merge window.

In the meantime, does the patch I sent out help people? I'd like to get 
feedback, but I'm a lazy bum, and don't use DEBUG_PAGEALLOC myself, so I 
was hoping that people who actually see this could comment on my untested 
suggestion.

		Linus
