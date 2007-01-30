Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbXA3TMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbXA3TMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbXA3TMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:12:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:57398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXA3TMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:12:15 -0500
Date: Tue, 30 Jan 2007 11:11:17 -0800
From: Greg KH <greg@kroah.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130191117.GG20642@kroah.com>
References: <20070130012904.GA9617@kroah.com> <1a297b360701300930m90a09bbp30bed58c9c9bf456@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360701300930m90a09bbp30bed58c9c9bf456@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:30:23PM +0400, Manu Abraham wrote:
> 
> Sounds very nice indeed. Just happened to do a driver in a similar
> status, where the vendor did not want to make the specs and other
> stuff open, but was in a position to support an OSS driver for the
> STB0899 demodulator driver from ST Microelectronics
> 
> I think many vendors will be ready to jump in.

Based on the initial response so far, a number of them seem very
willing.

> the STB0899 demodulator driver is now available at
> 
> http://linuxtv.org/hg/~manu/stb0899-c5
> 
> It needs some fixes with regards to our DVB API. (bumping it up to 3.2
> from 3.1) It's almost ready to rock now, with new delivery systems.

Glad to see that we are getting more device support :)

thanks,

greg k-h
