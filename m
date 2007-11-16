Return-Path: <linux-kernel-owner+w=401wt.eu-S1764970AbXKPTkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764970AbXKPTkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXKPTkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:40:06 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:53219 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbXKPTkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:40:03 -0500
Date: Fri, 16 Nov 2007 21:39:58 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.2
Message-ID: <20071116193958.GJ6372@mea-ext.zmailer.org>
References: <20071116183752.GA9807@kroah.com> <20071116183940.GC9807@kroah.com> <473DF101.3010501@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473DF101.3010501@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 02:35:29PM -0500, Mark Lord wrote:
> Greg Kroah-Hartman wrote:
>> We (the -stable team) are announcing the release of the 2.6.23.2 kernel.
>> It contains a number of bugfixes for the core kernel code.
>> I'll also be replying to this message with a copy of the patch between
>> 2.6.23.1 and 2.6.23.2
> ..
>> Tsugikazu Shibata (1):
>>       HOWTO: update ja_JP/HOWTO with latest changes
> ..
>
> So what is the magic command to apply this patch successfully?
> It keeps rejecting the Documentation/ja_JP/HOWTO updates here.

Hammer GIT coders into sensibility to add proper MIME headers
on these patch post.  Then, perhaps, things will just work.
(and postmaster won't get tons of rejects..)

  /Matti Aarnio  -- one of  <postmaster@vger.kernel.org>
