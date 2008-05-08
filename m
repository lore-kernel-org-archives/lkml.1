Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbYEHVGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbYEHVGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763070AbYEHVF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:05:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762026AbYEHVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:05:55 -0400
Date: Thu, 8 May 2008 13:29:21 -0700
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080508202921.GA32617@kroah.com>
References: <20080505080227.GA5499@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505080227.GA5499@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 10:02:27AM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> as of some high versions of 2.6.25-gitXX and 2.6.26-rc1, USB devices pluged
> into a dock (minidock for Lenovo ThinkPad T61) are not discoverred until
> I reload ehci-hcd module with already plugged device.

Can you please post the kernel log file from when this happens?

Added the linux-usb list on the CC: for this as well...

thanks,

greg k-h
