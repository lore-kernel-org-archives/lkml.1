Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZJ0FUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZJ0FUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZJ0FUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:20:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56866
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbZJ0FUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:20:49 -0400
Date: Mon, 26 Oct 2009 22:21:12 -0700 (PDT)
Message-Id: <20091026.222112.23063030.davem@davemloft.net>
To: david@lang.hm
Cc: gregkh@suse.de, linville@tuxdriver.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
References: <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
	<20091026184734.GA21591@suse.de>
	<alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: david@lang.hm
Date: Mon, 26 Oct 2009 21:17:55 -0700 (PDT)

> On Mon, 26 Oct 2009, Greg KH wrote:
> 
>> Do you have this kind of hardware and are willing to accept ownership
>> of
>> this driver?
> 
> no, I do not have the hardware, but if there are no bugs reported
> against this driverit would seem that having a 'maintainer' who made
> absolutly no changes to the driver (just allowing API changes by
> others to be implemented) would be the same thing as having no
> maintainer, but in the first case you are willing to have the driver
> in the kernel, in the other you want to rip it out.

Nobody is using this driver, and we're pretty damn confident
of that.
