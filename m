Return-Path: <linux-kernel-owner+w=401wt.eu-S1031370AbXDZRcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031370AbXDZRcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031371AbXDZRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:32:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:52503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031370AbXDZRcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:32:54 -0400
Date: Thu, 26 Apr 2007 10:30:28 -0700
From: Greg KH <gregkh@suse.de>
To: David Lang <david.lang@digitalinsight.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, cebbert@redhat.com
Subject: Re: [patch 00/33] 2.6.20-stable review
Message-ID: <20070426173028.GA16886@suse.de>
References: <20070426165445.GA1898@kroah.com> <Pine.LNX.4.63.0704260945090.9674@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704260945090.9674@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:48:22AM -0700, David Lang wrote:
>  any idea why there are so many more -stable patches for 2.6.20? this is the 
>  10th -stable series, and most of them have been dozens of patches.
> 
>  is there a new team reporting and fixing bugs? or were there just more small 
>  problems found in 2.6.20 then normal? or something else?

I think it's entirely due to the awesome effort by Chuck Ebbert of Red
Hat.  He has been digging through all of the applied patches to Linus's
tree and been forwarding them on to the stable team.  Without his effort
and help, we would not have so many patches in these releases.

I know I personally owe him at least one beer if I run into him at some
conference, and I think all other users of the stable tree do too.

thanks,

greg k-h
