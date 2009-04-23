Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZDWLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZDWLP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZDWLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:15:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54191 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZDWLPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:15:13 -0400
Message-ID: <49F04D7C.2040807@garzik.org>
Date: Thu, 23 Apr 2009 07:14:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 2.6.30-rc3
References: <20090423103523.GT4593@kernel.dk>
In-Reply-To: <20090423103523.GT4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Bartlomiej Zolnierkiewicz (1):
>       block: enable by default support for large devices and files on 32-bit archs

Although I strongly support this change -- is this really appropriate 
for -rc3?

I know it's only a one-line Kconfig change, but still...  this does not 
seem to fall into the category of "regression fix."

	Jeff


