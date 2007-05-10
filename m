Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbXEJWpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbXEJWpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXEJWpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:45:46 -0400
Received: from gw.goop.org ([64.81.55.164]:51150 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbXEJWpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:45:45 -0400
Message-ID: <4643A096.7000909@goop.org>
Date: Thu, 10 May 2007 15:45:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, herbert@gondor.apana.org.au, hch@infradead.org,
       ak@suse.de, virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org,
       shemminger@linux-foundation.org, rusty@rustcorp.com.au,
       Valdis.Kletnieks@vt.edu
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
References: <464395E5.2090500@goop.org>	<20070510151426.d808384f.akpm@linux-foundation.org>	<46439B19.7010706@goop.org> <20070510.152552.117703057.davem@davemloft.net>
In-Reply-To: <20070510.152552.117703057.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I'm not so certain now that we know it's the jiffies wrap point :-)
>
> The fixes in question are attached below and they were posted and
> discussed on netdev:
>   

Yep, this patch gets rid of my spinning thread.  I can't find this patch
or any discussion on marc.info; is there a better netdev list archive?

    J
