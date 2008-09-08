Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYIIDMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYIIDMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYIIDMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:12:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:36150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYIIDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:12:44 -0400
Date: Mon, 8 Sep 2008 14:06:56 -0700
From: Greg KH <gregkh@suse.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.17
Message-ID: <20080908210656.GA3852@suse.de>
References: <20080908143516.GA7311@suse.de> <Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 03:44:53PM -0400, linux-os (Dick Johnson) wrote:
> 
> On Mon, 8 Sep 2008, Greg KH wrote:
> 
> > We (the -stable team) are announcing the release of the 2.6.25.17
> > kernel.
> [SNIPPED...]
> 
> I have a dual AMD Dell that I installed 2.6.25.17 into. It
> produces severe FS corruption on a Serial ATA drive if I
> build a kernel on it. I can build the kernel on one of my
> SCSI drives with no problems.

Is this something new with 2.6.25.17, or has it always been the same for
all 2.6.25 kernels?

thanks,

greg k-h
