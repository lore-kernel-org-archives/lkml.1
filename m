Return-Path: <linux-kernel-owner+w=401wt.eu-S1767575AbXCIWci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767575AbXCIWci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767574AbXCIWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:32:38 -0500
Received: from 1wt.eu ([62.212.114.60]:1091 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767575AbXCIWcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:32:36 -0500
Date: Fri, 9 Mar 2007 23:31:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309223152.GA1407@1wt.eu>
References: <20070309053931.GA10459@waste.org> <20070309213959.GI10394@waste.org> <20070309215716.GK943@1wt.eu> <200703100912.07792.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703100912.07792.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 09:12:07AM +1100, Con Kolivas wrote:
(...)
> > Matt, could you check with plain 2.6.20 + Con's patch ? It is possible
> > that he added bugs when porting to -mm, or that someting in -mm causes
> > the trouble. Your experience with -mm seems so much different from mine
> > with mainline, there must be a difference somewhere !
> 
> Good idea.

OK, so let me summarize :

  plain 2.6.20
  + http://www.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.2.bz2
  + http://ck.kolivas.org/patches/staircase-deadline/sched-rsdl-0.26.patch
  + http://marc.theaimsgroup.com/?l=linux-kernel&m=117347544926731&q=raw

should be a good starting point.

> > Con, is your patch necessary for mainline patch too ? I see that it
> > should apply, but sometimes -mm may justify changes.
> 
> Yes it will be necessary for the mainline patch too.

OK Thanks Con.

Best regards,
Willy

