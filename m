Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbXEJWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbXEJWza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXEJWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:55:22 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51137 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXEJWzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:55:21 -0400
Date: Thu, 10 May 2007 15:53:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       herbert@gondor.apana.org.au, hch@infradead.org, ak@suse.de,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org,
       shemminger@linux-foundation.org, rusty@rustcorp.com.au,
       Valdis.Kletnieks@vt.edu
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
Message-ID: <20070510225308.GL3505@sequoia.sous-sol.org>
References: <464395E5.2090500@goop.org> <20070510151426.d808384f.akpm@linux-foundation.org> <46439B19.7010706@goop.org> <20070510.152552.117703057.davem@davemloft.net> <4643A096.7000909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643A096.7000909@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Yep, this patch gets rid of my spinning thread.  I can't find this patch
> or any discussion on marc.info; is there a better netdev list archive?

See the "linkwatch bustage in git-net" thread on netdev

http://thread.gmane.org/gmane.linux.network/61800/focus=61812
