Return-Path: <linux-kernel-owner+w=401wt.eu-S1765957AbXHWXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765957AbXHWXBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761048AbXHWXB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:01:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:60906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760910AbXHWXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:01:28 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19yecFE3SByuRcJ/WtiytR5RRz/T6AoaiDBo+tOlp
	bUo8JYDsiB5ngb
Date: Fri, 24 Aug 2007 01:01:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.23-rc3
In-Reply-To: <20070823224956.GA25969@suse.de>
Message-ID: <Pine.LNX.4.60.0708240059090.3246@poirot.grange>
References: <20070822220805.GB30603@kroah.com> <Pine.LNX.4.60.0708240036200.3246@poirot.grange>
 <20070823224956.GA25969@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Greg KH wrote:

> Unfortunately, I really like the cascade affect, it shows that the
> patches do have to be applied in consecutive order for them to work
> properly (which some people seem to forget and then get mad at me when
> they try to cherry-pick intermediate patches and apply them to older
> kernels for odd reasons...)
> 
> If I wanted to respond in an egotistical way, I could just tell you to
> use an email client that can handle the cascade affect properly, like
> mine does :)

Fair enough:-) No problem. Obviously, your argument has higher priority 
than mine, so, if this really becomes a problem for me, I'll find a 
solution for it, as well as everybody else suffering from this style.

Thanks
Guennadi
---
Guennadi Liakhovetski
