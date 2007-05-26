Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXEZHnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXEZHnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 03:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXEZHno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 03:43:44 -0400
Received: from mail.suse.de ([195.135.220.2]:43925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXEZHnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 03:43:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] x86: fix oprofile double free (was Re: Multiple free during oprofile unload)
Date: Sat, 26 May 2007 09:43:21 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <4656FA04.5000403@redhat.com> <20070525193737.34609de2@the-village.bc.nu> <20070526022741.GD3390@sequoia.sous-sol.org>
In-Reply-To: <20070526022741.GD3390@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705260943.21541.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> And, in this case we're in luck.  It's not released in any -stable tree
> yet (it's queued for the next release).  So there's plenty of time to
> fix it up before next -stable release.
> 
> Something like below should fix it.

I already got a similar patch, but not tested yet.

-Andi
