Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXIDBv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXIDBv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 21:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXIDBvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 21:51:21 -0400
Received: from msr54.hinet.net ([168.95.4.154]:59913 "EHLO msr54.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXIDBvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 21:51:20 -0400
Subject: Re: IP1000A network driver in Linux tree?
From: Jesse Huang <jesse@icplus.com.tw>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 04 Sep 2007 09:35:12 -0400
Message-Id: <1188912912.2184.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 (2.6.0-1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All:

Was IC Plus IP1000A Linux Driver in kernel tree or not? Our customer is pushing us to put it into kernel. Is there anything that we should do?

Thanks.
Best Regards,
Jesse Huang

-----Original Message-----
From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
Sent: Tuesday, June 12, 2007 6:50 AM
To: Caio Marcelo
Cc: jesse@icplus.com.tw
Subject: Re: IP1000A network driver in Linux tree?

Caio Marcelo <cmarcelo@gmail.com> :
[...]
> The "ipg" driver (for IP1000A) isn't part of Linux kernel tree today, 
> but looking at mailing lists I've found messages indicating that it 
> would be. Something happened? Is something missing to make it get into 
> Linux tree? Do you need help, I'm not an expert on the area (network
> drivers) but I would be glad to help, or at least try to help :)

You can clone a standard git tree of the kernel, then fetch the 'ipg' branch at:

git://electric-eye.fr.zoreil.com/home/romieu/linux/linux-2.6-out

It should be safe up to commit f66b763f55de7fa863beb954ccef9fe3b044955d

After this commit... Well, I should really try my own dog food before advertising it :o)

-- 
Ueimor


