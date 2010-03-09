Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0CITmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:42:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:51071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab0CITm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:42:29 -0500
Date: Tue, 9 Mar 2010 11:42:01 -0800
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sysfs: Fixup broken chown tracking
Message-ID: <20100309194201.GA869@suse.de>
References: <20100309191127.GA30462@obsidianresearch.com>
 <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 02:36:12PM -0500, David P. Quigley wrote:
> It looks like your patch is already in the tree as commit
> 7c0ff870d1ed287504a61ed865f3d728c757436b. We saw this problem before and
> Eric fixed it up. I thought it was very odd that you posted this 5
> minutes ago and it was already upstream.

Yeah, this has already been resolved, did that patch not solve the issue
for you?

thanks,

greg k-h
