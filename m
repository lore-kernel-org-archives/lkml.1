Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXKZWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXKZWQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXKZWQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:16:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXKZWQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:16:07 -0500
Date: Mon, 26 Nov 2007 14:15:45 -0800
From: Greg KH <gregkh@suse.de>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       lcm@us.ibm.com
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071126221545.GA15268@suse.de>
References: <4742CB2C.76E4.0078.0@novell.com> <20071120174945.GA6024@us.ibm.com> <47440D1F.76E4.0078.0@novell.com> <20071126215953.GA23277@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126215953.GA23277@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 01:59:54PM -0800, Gary Hade wrote:
> Greg, 
> Without a closer look at the code and the information I
> requested above I am not 100% certain that my expansion ROM
> allocation fix is incomplete but it seems pretty likely that
> it is.  If you feel that the possible regression that Jan
> reported is more important than the issue I was trying to solve
> feel free to remove the change until I can come up with
> something better.

If you want me to revert the changes in Linus's tree right now, that's
fine, I will, just send me a patch to do so.

But if you think you can work to solve this problem quickly, then I'm
more than willing to keep the changes in the tree.

It's up to you.

thanks,

greg k-h
