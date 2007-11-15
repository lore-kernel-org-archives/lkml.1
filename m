Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXKOWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXKOWMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbXKOWMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:12:14 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:36578 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbXKOWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:12:13 -0500
Message-ID: <473CC42C.2080601@nortel.com>
Date: Thu, 15 Nov 2007 16:11:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm, riel <riel@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel Bugs)
References: <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <1195162015.22457.52.camel@lappy> <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2007 22:12:00.0566 (UTC) FILETIME=[8B6B1560:01C827D4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> So the _only_ explanation today for 12GB on a 32-bit machine is
>  (a) insanity
> or 
>  (b) being so lazy as to not bother to upgrade
> and in either case, my personal reaction is "I'm *not* crazy, and yes, I'm 
> lazy too, and I can't give a rats *ss about those problems".

How about...

c) they bought it at the beginning of a project and are stuck with it 
because they aren't getting any more money for hardware

d) they've shipped it to the field and have to support it

We've got some 32-bit 8GB boxes for which both of these would hold true.

Chris
