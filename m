Return-Path: <linux-kernel-owner+w=401wt.eu-S965579AbXA3SUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579AbXA3SUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXA3SUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:20:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48713 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965579AbXA3SUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:20:12 -0500
Message-ID: <45BF8C57.1020500@garzik.org>
Date: Tue, 30 Jan 2007 13:20:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
In-Reply-To: <ada8xfks90x.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Just look at the in-tree drivers: there are tons of them that don't
> work on big-endian platforms, or have 64-bit problems, or have no SMP
> support.  And that doesn't even count drivers that are so bitrotted
> they won't even build any more.

The vast majority of these were submitted ages ago.  Standards for 
acceptance and maintenance have risen since the days of ISA drivers and 
floppy tape drives.

I think it's quite disingenuous to imply that a few bad apples are a 
representative sample.

	Jeff


