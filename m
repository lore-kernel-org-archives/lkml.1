Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXLDQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXLDQE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXLDQEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:04:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36595 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXLDQEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:04:21 -0500
Message-ID: <47557A7D.6010409@garzik.org>
Date: Tue, 04 Dec 2007 11:04:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc4
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <alpine.LFD.0.99999.0712040819080.555@xanadu.home>
In-Reply-To: <alpine.LFD.0.99999.0712040819080.555@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> On Mon, 3 Dec 2007, Linus Torvalds wrote:
> 
>> That said, none of the changes are really _exciting_ or really scary. And 
>> we should have fixed a number of regressions, although more certainly 
>> remain.
> 
> Any reason for this:
> 
>  mode change 100644 => 100755 drivers/net/chelsio/cxgb2.c
>  mode change 100644 => 100755 drivers/net/chelsio/pm3393.c
>  mode change 100644 => 100755 drivers/net/chelsio/sge.c
>  mode change 100644 => 100755 drivers/net/chelsio/sge.h

As repeatedly mentioned on the list :) it is a mistake.

	Jeff



