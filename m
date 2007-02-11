Return-Path: <linux-kernel-owner+w=401wt.eu-S1750745AbXBKRP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750745AbXBKRP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbXBKRP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:15:56 -0500
Received: from mail.globalsuite.net ([69.46.103.200]:45608 "HELO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750743AbXBKRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:15:55 -0500
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 12:15:45 EST
X-AuditID: c0a8013c-afb75bb000003c54-93-45cf49dd23cb 
Date: Sun, 11 Feb 2007 17:53:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
Message-ID: <20070211165302.GO6458@kernel.dk>
References: <20070209190307.GC6152@kernel.dk> <200702110002.38328.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702110002.38328.lenb@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11 2007, Len Brown wrote:
> On Friday 09 February 2007 14:03, Jens Axboe wrote:
> > Hi,
> > 
> > Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> > but of course preparing a new kernel for the laptop is something you
> > want to do right before leaving. So I discovered that the current (well
> > as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> > doesn't resume on my x60. 2.6.20 works fine, so something broke since
> > then.
> 
> resume from RAM, or resume from disk?

Resume from RAM, I never use suspend-to-disk.

-- 
Jens Axboe

