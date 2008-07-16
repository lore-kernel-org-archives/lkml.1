Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYGPLE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYGPLE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYGPLEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:04:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYGPLEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:04:49 -0400
Date: Wed, 16 Jul 2008 04:04:47 -0700 (PDT)
Message-Id: <20080716.040447.249346237.davem@davemloft.net>
To: pageexec@freemail.hu
Cc: tiago@assumpcao.org, torvalds@linux-foundation.org, greg@kroah.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
From: David Miller <davem@davemloft.net>
In-Reply-To: <487DEED3.1351.1EF6349A@pageexec.freemail.hu>
References: <487DE856.15132.1EDCDAAF@pageexec.freemail.hu>
	<20080716.033112.193697209.davem@davemloft.net>
	<487DEED3.1351.1EF6349A@pageexec.freemail.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pageexec@freemail.hu
Date: Wed, 16 Jul 2008 12:51:31 +0200

> On 16 Jul 2008 at 3:31, David Miller wrote:
> 
> > From: pageexec@freemail.hu
> > Date: Wed, 16 Jul 2008 12:23:50 +0200
> > 
> > > On 16 Jul 2008 at 3:08, David Miller wrote:
> > > 
> > > > IOW, when we fix security issues, it's simply not even appropriate or 
> > > > relevant to you.
> > > 
> > > i'll ask again: why aren't security fixes that you fix relevant to users
> > > of older kernels (as that's what the topic was)?
> > 
> > Backporting any fix to older kernels is a chore, the further back you
> > go, the harder and less fun it is.
 ...
> > The tipping point is really quick to where someone hacking the kernel
> > for fun simply isn't going to do it, nor should they be expected to.
> > 
> > That's why people who want a stable supported kernel with fixes
> > constantly backported have grown accustomed to paying for that service.
> 
> and how does that imply that you should not mark security fixes as such?

You asked me why fixes are not relevant to users of older upstream
non-dist kernels.  And I answered that question.
