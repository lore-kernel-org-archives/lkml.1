Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbXISNXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbXISNXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXISNW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:22:57 -0400
Received: from mx12.go2.pl ([193.17.41.142]:53003 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbXISNW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:22:57 -0400
Date: Wed, 19 Sep 2007 15:25:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org, "Rafael J\. Wysocki" <rjw@sisk.pl>
Subject: Re: PCI Interrupt
Message-ID: <20070919132500.GD3226@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F12244.22016.47D8DCD0@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-09-2007 13:21, Frantisek Rysanek wrote:
> On 19 Sep 2007 at 12:14, Jarek Poplawski wrote:
>> On 18-09-2007 16:42, Rafael J. Wysocki wrote:
>>> Hm, edge-triggered interrupts cannot be shared, AFAIK.
>>>
>> Let's agree it's only a superstition...
>> http://en.wikipedia.org/wiki/Edge_triggered_interrupt
>>
> Superstition? Depends on how stringent your requirements are.
> 

My requirements aren't stringent at all. They are general like the
sentence: "edge-triggered interrupts cannot be shared", which, IMHO,
could mislead somebody. So, it's only about "cannot" vs. "cannot (or
is not recommended/implemented) with some kind of hardware (like PC)".

Regards,
Jarek P.
