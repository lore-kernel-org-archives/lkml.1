Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYGWGM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYGWGM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 02:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYGWGMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 02:12:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYGWGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 02:12:17 -0400
Date: Tue, 22 Jul 2008 23:09:08 -0700
From: Greg KH <greg@kroah.com>
To: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <teheo@suse.de>, Greg K-H <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sysfs: Support sysfs_notify from atomic context
	with new sysfs_notify_dirent
Message-ID: <20080723060908.GA7689@kroah.com>
References: <18557.11132.728439.827572@notabene.brown> <487D2F01.5000404@suse.de> <18562.56270.855607.668110@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18562.56270.855607.668110@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 04:31:42PM +1000, Neil Brown wrote:
> 
> Greg:  Can you take this one now?  Thanks.

Yes, I'll add this to my queue.

thanks,

greg k-h
