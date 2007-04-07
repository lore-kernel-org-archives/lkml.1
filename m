Return-Path: <linux-kernel-owner+w=401wt.eu-S966274AbXDGSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966274AbXDGSvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966283AbXDGSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:51:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966274AbXDGSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:51:20 -0400
Date: Sat, 7 Apr 2007 11:51:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc6
In-Reply-To: <Pine.LNX.4.64.0704071145410.6730@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704071150010.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
 <20070407113747.6640b1ba.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0704071145410.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Apr 2007, Linus Torvalds wrote:

> 
> 
> On Sat, 7 Apr 2007, Randy Dunlap wrote:
> > 
> > Is it too late to get a v2.6.21-rc6 tag ?
> 
> It's definitely there, I can see it in gitweb..
> 
> Do you have some really ancient git that didn't fetch the tags 
> automatically?

Oh, my bad. I'd tagged it, but I didn't *sign* the tag, so it was just a 
tag-reference (and git fetch won't fetch them by default).

I replaced the v2.6.21-rc6 tag with a signed one. Do 

	git fetch --tags

to get the thing.

		Linus
