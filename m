Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524Ab0ABGC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0ABGC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125Ab0ABGC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:02:58 -0500
Received: from kroah.org ([198.145.64.141]:57944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0ABGC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:02:57 -0500
Date: Thu, 31 Dec 2009 16:19:31 -0800
From: Greg KH <greg@kroah.com>
To: Peter Paul <abnominales@web.de>, linux-kernel@vger.kernel.org
Subject: Re: BCM70010 (crystalhd) Linux Driver
Message-ID: <20100101001931.GA1290@kroah.com>
References: <523138909@web.de> <20091231131852.GB32492@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231131852.GB32492@centrinvest.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 04:18:52PM +0300, Andrey Panin wrote:
> On 364, 12 30, 2009 at 09:06:15PM +0100, Peter Paul wrote:
> > Broadcom has just released a linux driver for their BCM70012 and BCM70015 Crystal HD High Definition video decoders under the GPLv2 licence. [1]
> > Maybe you want to have a look at them.
> > 
> > [1] http://www.broadcom.com/support/crystal_hd/
> 
> >From quick inspection kernel part looks much better than most vendor-provided
> drivers. It needs some cleanups and bugfixes, for example error handling in
> device probe function doesn't look right to me, driver can't handle more than
> one device as far as I can see (I don't know is it really needed though), etc.
> But anyway this driver definitely deserves putting into staging.

I'm glad to do so if someone wants to help work on it there and shephard
it into the main kernel tree.

thanks,

greg k-h
