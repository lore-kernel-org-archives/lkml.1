Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbZDQMVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbZDQMVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZDQMVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:21:23 -0400
Received: from relay3.sgi.com ([192.48.156.57]:46600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbZDQMVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:21:23 -0400
Date: Fri, 17 Apr 2009 07:21:21 -0500
From: Robin Holt <holt@sgi.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: David Miller <davem@davemloft.net>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Benjamin Li <benli@broadcom.com>, Michael Chan <mchan@broadcom.com>,
       "holt@sgi.com" <holt@sgi.com>, James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC
	addresses on BCM5701
Message-ID: <20090417122121.GP10768@sgi.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.LI.Sw85JB@chimera> <20090416.174310.260350758.davem@davemloft.net> <20090417005804.GA16432@xw6200.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417005804.GA16432@xw6200.broadcom.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I think we do have a fix for this.  James and Robin both
> reported that the test patch I sent out worked for them.  I'm preparing
> a patchset for submission now.
> 
> James, Robin, can you confirm that you performed your tests with David's
> patch reverted?

My test was done with the 2.6.28-rc1 kernel plus your patch and no
others.

Robin
