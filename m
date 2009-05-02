Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZEBQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZEBQ7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZEBQ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:59:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50984 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZEBQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:59:41 -0400
Message-ID: <49FC7BF5.8080502@garzik.org>
Date: Sat, 02 May 2009 12:59:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev	tmpfs
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org>
In-Reply-To: <20090502071636.GA9487@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
> 
> Umm, guys this needs much broader discussion than just sneaking in
> a patch under the covers.
> 
> It basically does re-introduce devfs under a different name, and from
> looking at the implementation it might not be quite as bad a Gooch's
> original, but it's certainly worse than Adam Richters rewrite the we
> never ended up merging.

I was interested in this Richter devfs rewrite, since I was unfamiliar 
with it.

For the benefit of the thread, here is a URL that people can examine:

	http://marc.info/?l=linux-kernel&m=104138806530375&w=2

Regards,

	Jeff



