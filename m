Return-Path: <linux-kernel-owner+w=401wt.eu-S1161745AbXDXMha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161745AbXDXMha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161750AbXDXMha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:37:30 -0400
Received: from [70.254.190.220] ([70.254.190.220]:51240 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161745AbXDXMh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:37:29 -0400
Date: Tue, 24 Apr 2007 12:37:28 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq default governor
In-Reply-To: <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704241235560.25153@server.thyself>
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
 <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Michal Piotrowski wrote:

> Hi William,
>
> On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
>>  Question: is there some reason that kconfig does not allow for default
>>  governors of conservative/ondemand/powersave?
>
> Performance?
>
>>  I'm not aware of any reason why one of those governors could not be used
>>  as default.
>
> My hardware doesn't work properly with ondemand governor. I hear
> strange noises when frequency is changed.
>

That doesn't mean it isn't working, though. I here weird noises if the cpu 
is clocked anywhere from 333MHz to 1GHz (sounds like an RD-D2 beeping 
noises in ultra high pitch?)

  William Heimbigner
icxcnika@mar.tar.cc
