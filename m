Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFBWSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFBWSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbXFBWSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:18:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34588 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbXFBWSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:18:36 -0400
Message-ID: <4661ECB4.7020902@garzik.org>
Date: Sat, 02 Jun 2007 18:18:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Tejun Heo <htejun@gmail.com>, David Greaves <david@dgreaves.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <8rnax-6XX-11@gated-at.bofh.it> <8rA7H-1B4-1@gated-at.bofh.it> <E1Hub8O-0000rF-Hb@be1.lrz>
In-Reply-To: <E1Hub8O-0000rF-Hb@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Therefore I suggest setting the smart-enabled-bit in the kernel, in spite of
> not being the kernel's duty. It would be a 99,99% DTRT.

NAK.  That's hardcoding policy in the kernel.

	Jeff


