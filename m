Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbZDGWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbZDGWac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbZDGWaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:30:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45771 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZDGWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:30:17 -0400
Message-ID: <49DBD3EE.3010601@garzik.org>
Date: Tue, 07 Apr 2009 18:30:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE updates part 4
References: <200904080020.43175.bzolnier@gmail.com>
In-Reply-To: <200904080020.43175.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> - TRIM support ("discard" operation for SSD devices)
>   (David Woodhouse & Matthew Wilcox)
> 
>   Since this is a new feature and hasn't seen much testing with production
>   devices it is not enabled by default yet (requires use of "ide_core.trim=1"
>   kernel parameter).


As noted by Matthew, this appears to be missing the requisite block support?

	Jeff



