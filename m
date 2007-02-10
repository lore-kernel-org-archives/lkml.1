Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXBJLYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXBJLYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXBJLYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:24:36 -0500
Received: from brick.kernel.dk ([62.242.22.158]:23966 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXBJLYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:24:36 -0500
Date: Sat, 10 Feb 2007 12:24:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
Message-ID: <20070210112457.GK6152@kernel.dk>
References: <20070209190307.GC6152@kernel.dk> <200702101049.47889.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702101049.47889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10 2007, Rafael J. Wysocki wrote:
> Hi,
> 
> On Friday, 9 February 2007 20:03, Jens Axboe wrote:
> > Hi,
> > 
> > Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> > but of course preparing a new kernel for the laptop is something you
> > want to do right before leaving. So I discovered that the current (well
> > as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> > doesn't resume on my x60. 2.6.20 works fine, so something broke since
> > then.
> 
> I think the patch from
> 
> http://marc.theaimsgroup.com/?l=linux-acpi&m=117103448629685&w=2
> 
> is likely to help.

Thanks, will give it a shot.

-- 
Jens Axboe

