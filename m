Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbXHDEQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbXHDEQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 00:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXHDEQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 00:16:34 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50713
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXHDEQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 00:16:34 -0400
Date: Fri, 3 Aug 2007 21:14:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708032106560.6905@asgard.lang.hm>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Linus Torvalds wrote:

> So I tried to hold people to the merge window, and said no to a few pull
> requests, but this whole "-rc2 is the new -rc1" thing is a disease, and
> not only is -rc2 late, it's bigger than it should be. Oh, well.

I don't think this is new, -rc1 has always been a mid-merge sync point as 
much as (or more then) a release candidate. I can't think of any -rc2s 
that haven't included fairly significant merges since -rc1. now some of 
the -rc1s have been more useable then others, and this series does look 
like it's going to be rougher and longer then most (due in large part to 
the scheduler changes), but it's more a difference in degree then in type.

David Lang
