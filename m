Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXI2FcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXI2FcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 01:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXI2Fb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 01:31:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47970 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXI2Fb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 01:31:58 -0400
Message-ID: <46FDE348.3010801@pobox.com>
Date: Sat, 29 Sep 2007 01:31:52 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Andy Fleming <afleming@freescale.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: Spinlock fixes for softirqs
References: <Pine.LNX.4.64N.0709181532190.9650@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709181532190.9650@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

doesn't Andrew have a version of these patches that move the useful 
patch text into the area where it will get copied into the permanent 
kernel changelog?

also, your PHYLIB patches give no notion at all of proper patch order.


