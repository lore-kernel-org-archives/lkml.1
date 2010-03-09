Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0CITr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:47:59 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:37923 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0CITr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:47:56 -0500
Subject: Re: [PATCH] sysfs: Fixup broken chown tracking
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Greg KH <gregkh@suse.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <20100309194201.GA869@suse.de>
References: <20100309191127.GA30462@obsidianresearch.com>
	 <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil>
	 <20100309194201.GA869@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 09 Mar 2010 14:46:28 -0500
Message-Id: <1268163988.29493.1970.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 11:42 -0800, Greg KH wrote:
> On Tue, Mar 09, 2010 at 02:36:12PM -0500, David P. Quigley wrote:
> > It looks like your patch is already in the tree as commit
> > 7c0ff870d1ed287504a61ed865f3d728c757436b. We saw this problem before and
> > Eric fixed it up. I thought it was very odd that you posted this 5
> > minutes ago and it was already upstream.
> 
> Yeah, this has already been resolved, did that patch not solve the issue
> for you?
> 
> thanks,
> 
> greg k-h

I don't see how it couldn't have. The patch he submitted which he says
fixes the problem is the exact same patch that Eric submitted back in
Feb. Its possible that he is using a version of 2.6.33-rc8 that is based
off of a commit before the patch was merged since 2.6.33-rc8 was tagged
on Feb 12th and your commit date in the repo is Feb 16th.

