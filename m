Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZJNRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZJNRTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZJNRTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:19:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZJNRTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:19:42 -0400
Date: Wed, 14 Oct 2009 10:16:03 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, Bill Pemberton <wfp5p@virginia.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: Comedi: Add missing <linux/sched.h> includes
Message-ID: <20091014171603.GA28296@suse.de>
References: <adazl7taok3.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazl7taok3.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:11:08AM -0700, Roland Dreier wrote:
> Fix fallout of removal of sched.h from interrupt.h.  This fixes build
> breakage in staging drivers.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Already in my tree :(

thanks,

greg k-h
