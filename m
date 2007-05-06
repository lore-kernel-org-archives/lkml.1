Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbXEFSOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbXEFSOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXEFSOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:14:35 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4517 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbXEFSOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:14:34 -0400
Date: Sun, 6 May 2007 19:14:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Corey Minyard <minyard@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the LSR and MSR
Message-ID: <20070506181422.GB21158@flint.arm.linux.org.uk>
Mail-Followup-To: Gene Heskett <gene.heskett@gmail.com>,
	Corey Minyard <minyard@acm.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070504131532.GA12265@localdomain> <200705041304.02618.gene.heskett@gmail.com> <463B7FBC.3090907@acm.org> <200705061258.25351.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705061258.25351.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 12:58:25PM -0400, Gene Heskett wrote:
> [long message snipped]
>
> Thanks for your patience Corey.

So, in one sentence or preferably one word, did Corey's patch cause a
regression?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
