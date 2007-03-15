Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXCOEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXCOEM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbXCOEM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:12:28 -0400
Received: from s-utl02-sjpop.stsn.net ([72.254.0.202]:40471 "HELO
	s-utl02-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965045AbXCOEM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:12:27 -0400
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 00:12:27 EDT
Date: Wed, 14 Mar 2007 20:45:55 -0700
From: Greg KH <greg@kroah.com>
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net,
       mingo@elte.hu, stable@kernel.org, roland@redhat.com
Subject: Re: [stable] [PATCH] Fix COMPAT_VDSO regression bug
Message-ID: <20070315034555.GC6842@kroah.com>
References: <45F88780.1080507@wldelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F88780.1080507@wldelft.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:38:40AM +0100, Leroy van Logchem wrote:
> 
>     Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
>     This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.
> 
>     Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
>     reported in bug #8040. Reverting the above patch solved the problem.

What stable version did you revert this in that solved your problem?

thanks,

greg k-h

