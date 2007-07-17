Return-Path: <linux-kernel-owner+w=401wt.eu-S1764761AbXGQIHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764761AbXGQIHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXGQIGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:06:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:59731 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbXGQIGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:06:50 -0400
Date: Tue, 17 Jul 2007 01:04:12 -0700
From: Greg KH <gregkh@suse.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] no USB on M32R
Message-ID: <20070717080412.GA19377@suse.de>
References: <E1IAhoN-0001il-Ql@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IAhoN-0001il-Ql@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 08:49:35AM +0100, Al Viro wrote:
> 
> Won't build due to lack of dma-mapping.  Shouldn't that dependency
> (having PCMCIA => HCD possible) be on CARDBUS, anyway?

No, I think there are some older PCMCIA USB host controllers out there,
unfortunatly :(

thanks,

greg k-h
