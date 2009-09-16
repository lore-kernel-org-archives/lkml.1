Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZIPVfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZIPVfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZIPVfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:35:17 -0400
Received: from kroah.org ([198.145.64.141]:49507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZIPVfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:35:16 -0400
Date: Wed, 16 Sep 2009 14:09:56 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090916210956.GB24567@kroah.com>
References: <200909112223.n8BMMSHG002530@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909112223.n8BMMSHG002530@hera.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 12:22:22AM +0200, Tilman Schmidt wrote:
> [On holiday, answering from my nominally internet capable cellphone - please make allowances ...]
> 
> The stable patch claiming to correspond to Linus' tree patch
> 56f7efe48d57dda9e59e23ab161c118271cce815 and merged in 2.6.27.sth
> (eyact version not at hand) and 2.6.28.10 differs from the backported
> patch I submitted for stable myself. It breaks the driver completely,
> causing an oops and system malfunctions as soon as the device is
> connected. (Sorry for not noticing the vital difference at the time.)

No problem.

> The attached patch would fix the error by moving the code inswrted at
> the wrong place by the broken backported patch,, to the correct place
> where it went in the original patch. 

I see no patch attached here :(

> Alternativelyy, the broken backported could be reverted and my
> original bacport merged instead, if you can still find it.

I can not.

> Sorry for lack of references as i don't have acces to my development
> machine from here. Hope to have Cleared up the situation, anyway.

Can you send me what you need applied to the latest 2.6.27-stable tree
to fix this up so we can finally resolve this?

thanks,

greg k-h
