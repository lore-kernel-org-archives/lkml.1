Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYGaLq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYGaLq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYGaLqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:46:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYGaLqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:46:46 -0400
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com,
       mpm@selenic.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080731.043355.143045459.davem@davemloft.net>
References: <1217500967.3454.140.camel@pmac.infradead.org>
	 <20080731.035121.177567346.davem@davemloft.net>
	 <1217503770.3454.162.camel@pmac.infradead.org>
	 <20080731.043355.143045459.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 12:46:41 +0100
Message-Id: <1217504801.3454.170.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 04:33 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Thu, 31 Jul 2008 12:29:30 +0100
> 
> > After an offline discussion, I understand that if we can sort out the
> > actual technical issues, you'll carry this in the net tree. Thanks.
> 
> I will, but only because you threatened to bypass me and send them
> directly to Linus.  And frankly fighting someone willing to do things
> like that is simply not worth my time, so I'll just merge them
> blindly.

That doesn't make a lot of sense, Dave. Just because I _submit_ them to
Linus, that doesn't mean he automatically takes them.

I only said I'd submit them directly to Linus because I _think_ he'd
agree with Andrew and I, and take them despite your objections. And
because I think that's the right thing for him to do.

I wasn't going to hack hera and just put them into his tree by myself.

But don't let me talk you out of taking the patches... :)

> You just let me know when you think they are ready for inclusion.

I'll do that; thanks.

-- 
dwmw2

