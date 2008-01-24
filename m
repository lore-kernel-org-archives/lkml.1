Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYAXWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYAXWQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYAXWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:16:23 -0500
Received: from ns.suse.de ([195.135.220.2]:60081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbYAXWQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:16:22 -0500
Date: Thu, 24 Jan 2008 14:01:26 -0800
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 26/26] mount options: fix usbfs
Message-ID: <20080124220126.GA6185@suse.de>
References: <20080124193341.166753833@szeredi.hu> <20080124193457.628524720@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193457.628524720@szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 08:34:07PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a .show_options super operation to usbfs.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Looks good to me.  Do you want to take this through your tree, as it is
dependant on other changes, or do you want me to take this through the
USB tree?  Whatever is easier for you is fine for me.

thanks,

greg k-h
