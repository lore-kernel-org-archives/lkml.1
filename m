Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYCDTy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYCDTy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765928AbYCDTwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:52:54 -0500
Received: from mx1.suse.de ([195.135.220.2]:44907 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763565AbYCDTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:52:52 -0500
Date: Tue, 4 Mar 2008 11:35:41 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1
Message-ID: <20080304193541.GA5645@suse.de>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304125939.199a9f15@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304125939.199a9f15@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 12:59:39PM +0100, Cornelia Huck wrote:
> On Tue, 4 Mar 2008 01:19:28 -0800,
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > +driver-core-fix-cleanup-when-failing-device_add.patch
> 
> This should go into 2.6.25, as it fixes a panic (see
> http://marc.info/?l=linux-kernel&m=120411157302447&w=2,
> http://marc.info/?l=linux-kernel&m=120412001416810&w=2).

Will add it to that queue to send to Linus in a bit, thanks for poking
me.

Hint, when sending patches, please at least change the Subject so that I
don't accidentally pass it by, it was burried in a longer thread that I
missed the first time through.

thanks,

greg k-h
