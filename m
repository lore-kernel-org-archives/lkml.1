Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXBTVrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXBTVrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030460AbXBTVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:47:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47959 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXBTVrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:47:05 -0500
Message-ID: <45DB6C51.1080202@garzik.org>
Date: Tue, 20 Feb 2007 16:46:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <6bffcb0e0702190345p33f4832epec92656fff087f57@mail.gmail.com> <200702200104.57200.rjw@sisk.pl> <200702202216.03744.rjw@sisk.pl>
In-Reply-To: <200702202216.03744.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> FWIW, with CONFIG_PREEMPT unset (CONFIG_PREEMPT_VOLUNTARY is set instead), I'm
> unable to reproduce this problem on the box on which it is readily reproducible with
> CONFIG_PREEMPT set.

I'm not surprised...  I routinely tell people to turn it off, when 
debugging a problem.

	Jeff



