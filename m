Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZDAJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZDAJYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZDAJX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:23:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34190 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZDAJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:23:57 -0400
Message-ID: <49D332A0.5080107@garzik.org>
Date: Wed, 01 Apr 2009 05:23:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com>
In-Reply-To: <49C1331D.1080805@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> If anyone wants to actually run this code and test it
> then please start reading at:
>     http://open-osd.org
> You will need to checkout the out-of-tree git (below) for the user-mode utilities.
> Also the exofs.txt file in patch 7/8 should help


hum...  trying to play with this.  If you want exofs to go upstream, I 
think you should have a release tarball containing the user-mode utils 
posted somewhere.  Would make life a lot easier, both on early adopters 
and also on distribution packagers.

	Jeff



