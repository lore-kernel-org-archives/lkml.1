Return-Path: <linux-kernel-owner+w=401wt.eu-S967520AbXEHAQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967520AbXEHAQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967517AbXEHAQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:16:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967516AbXEHAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:16:49 -0400
Message-ID: <463FC0E4.8080908@redhat.com>
Date: Mon, 07 May 2007 20:14:28 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 6/6] firewire: add it all to kbuild
References: <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <tkrat.abd13e310a4516c7@s5r6.in-berlin.de> <20070502194442.GE1248@infradead.org> <46391834.2050209@s5r6.in-berlin.de> <20070503081011.GD23000@infradead.org>
In-Reply-To: <20070503081011.GD23000@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, May 03, 2007 at 01:01:08AM +0200, Stefan Richter wrote:
>> Christoph Hellwig wrote:
>>>> +fw-core-objs := fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
>>>> +	fw-device.o fw-cdev.o
>>> fw-core-y += ..
>>>
>> Like such?
> 
> Exactly.

OK, changed that here, will push out new patches soon.

Kristian
