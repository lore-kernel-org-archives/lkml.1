Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbXKLW4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbXKLW4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXKLWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:55:59 -0500
Received: from mx1.suse.de ([195.135.220.2]:44479 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbXKLWz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:55:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Date: Mon, 12 Nov 2007 23:55:54 +0100
User-Agent: KMail/1.9.6
Cc: gorcunov@gmail.com, tglx@linutronix.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20071112181747.GE7296@cvg> <200711122201.45269.ak@suse.de> <20071112.145049.125228420.davem@davemloft.net>
In-Reply-To: <20071112.145049.125228420.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711122355.55314.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 23:50:49 David Miller wrote:
> From: Andi Kleen <ak@suse.de>
> Date: Mon, 12 Nov 2007 22:01:45 +0100
> 
> > On Monday 12 November 2007 19:17:47 Cyrill Gorcunov wrote:
> > > This patch does remove trailing spaces from
> > > source files.
> > 
> > That will just cause a zillion patches to not apply anymore
> > with exactly 0 benefit.
> 
> You'll survive the x86 merge and you'll survive this
> patch too.

Sure, it's likely not your time that will be wasted.

Perhaps Lindent the whole tree then and drive everybody crazy
if you think such pointless changes are a good idea. I'm sure
it will make everything much better.

-Andi (who sees some evidence whitespace turns off some people's basic
cost:benefit brain functions) 
