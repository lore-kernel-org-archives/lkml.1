Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbYJJQGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbYJJQGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbYJJQF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:05:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47578 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761278AbYJJQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:05:55 -0400
To: greg@kroah.com
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, stable@kernel.org
In-reply-to: <20081010154946.GB20231@kroah.com> (message from Greg KH on Fri,
	10 Oct 2008 08:49:46 -0700)
Subject: Re: [stable] splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org> <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org> <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org> <E1KoEZM-0007Fb-5i@pomaz-ex.szeredi.hu> <20081010154946.GB20231@kroah.com>
Message-Id: <E1KoKUu-0000JV-Rb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 Oct 2008 18:05:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Greg KH wrote:
> On Fri, Oct 10, 2008 at 11:46:00AM +0200, Miklos Szeredi wrote:
> > I suspect this qualifies for stable kernels too.  Stable team, can you
> > please add this to your queue?
> 
> Queue for which kernel releases?  .25, .26, and/or .27?

25 and 26.  It's in .27.

Thanks,
Miklos
