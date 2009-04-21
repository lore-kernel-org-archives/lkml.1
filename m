Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZDUOCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZDUOCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZDUOB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:01:58 -0400
Received: from cathcart.site5.com ([74.54.107.137]:44738 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZDUOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:01:58 -0400
Message-ID: <49EDD1C9.2060408@compulab.co.il>
Date: Tue, 21 Apr 2009 17:01:45 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main> <49EDB569.2060701@compulab.co.il> <20090421125528.GD25828@sirena.org.uk> <49EDD02B.5020407@compulab.co.il> <20090421135640.GE25828@sirena.org.uk>
In-Reply-To: <20090421135640.GE25828@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Brown wrote:
> On Tue, Apr 21, 2009 at 04:54:51PM +0300, Mike Rapoport wrote:
>> Mark Brown wrote:
>>> On Tue, Apr 21, 2009 at 03:00:41PM +0300, Mike Rapoport wrote:
> 
>>>> I've managed to create some preliminary "line-consumer" driver. I don't really
>>>> like the name, but I couldn't think of something better and "virtual" is
>>>> already taken :)
> 
>>> "userspace" or "user"?  The goal here is to let userspace applications
>>> be consumers.
> 
>> I don't quite understand your intention here. Do you mean that it would bebetter
>> to use a character device rather than sysfs?
> 
> I'm talking about the name.

As I said, I could not invent something better. Any idea?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

