Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYBYMn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYBYMn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYBYMnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:43:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:54795 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752734AbYBYMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:43:17 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+R+BNoXt+RrAj/FMYWW7e6cZalLgoxLjYs5u9ZzJ
	YXqV4qYzLz3EQy
Date: Mon, 25 Feb 2008 13:43:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080220063834.GA22708@kroah.com>
Message-ID: <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Greg KH wrote:

> On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> > Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> > getting the following warnings (with a bit of context):
> 
> Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
> time from this?

dmesg output with CONFIG_LOG_BUF_SHIFT=19 sent privately to Greg as 
unpacked, as it would have to be sent to the list, is 408K big. Will see 
what Greg says.

Thanks
Guennadi
---
Guennadi Liakhovetski
