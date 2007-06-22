Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXFVFnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXFVFnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXFVFnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:43:03 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:48078 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXFVFnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:43:02 -0400
Date: Thu, 21 Jun 2007 22:43:04 -0700
From: Reza Roboubi <reza@parvan.net>
Subject: Re: O_DIRECT, fdatasync_area, mwrite
In-reply-to: <467ACB44.50209@earthdetails.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <467B6168.6090508@parvan.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <467ACB44.50209@earthdetails.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reza Roboubi wrote:
> Linus Torvalds:
>  > I suspect that this is about a few hundred lines of code (and a lot of
>  > testing). And you can emulate O_DIRECT behavior with it, along with
>  > splice (only for page-cache entities, though), and a lot of other
>  > off-by-one uses.
> ( http://lwn.net/2002/0516/a/lt-async.php3 )
> 
> I have often read this message and wondered why no one has implemented 
> it yet.  We would love to have such clean features instead of O_DIRECT. 
>  At this very moment it's a bit hard for us to do this(given a 
> prerequisites learning curve amongst other factors.)  We may at some 
> point do it and I'd love to contribute.  What _are_ the issues with it, 
>  and is there a technical reason it hasn't been implemented yet by anybody?
> 
> Further, is O_DIRECT to raw partition also unclean?

I know the top guys are very busy;  but I'd appreciate just a brief 
comment on the present situation.

Reza.
