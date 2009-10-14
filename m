Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZJNRwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZJNRwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZJNRwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:52:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZJNRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:52:15 -0400
Date: Wed, 14 Oct 2009 10:48:44 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, Bill Pemberton <wfp5p@virginia.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: Comedi: Add missing <linux/sched.h> includes
Message-ID: <20091014174844.GA3681@suse.de>
References: <adazl7taok3.fsf@cisco.com>
 <20091014171603.GA28296@suse.de>
 <adak4yxamzj.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak4yxamzj.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:45:04AM -0700, Roland Dreier wrote:
> 
>  > Already in my tree :(
> 
> Any plans to get it upstream?  As far as I can tell, these drivers
> haven't built since before -rc4, so 4 or 5 days at least.

They should go to Linus in a few hours, patience :)

The patches were also posted to lkml yesterday.

thanks,

greg k-h
