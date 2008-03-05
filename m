Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbYCEI7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbYCEI7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYCEI7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:59:42 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:36859 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYCEI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:59:41 -0500
Date: Wed, 5 Mar 2008 14:29:22 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Holger Kiehl <Holger.Kiehl@dwd.de>,
       linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080305085922.GA8951@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080304160940.GC19059@localhost.sw.ru> <20080304163339.GA11160@linux.vnet.ibm.com> <20080304192435.GA5525@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304192435.GA5525@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:24:36AM -0800, Greg KH wrote:
> On Tue, Mar 04, 2008 at 10:03:39PM +0530, Dhaval Giani wrote:
> > On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
> > > [Cc'ing /sys/kernel/uids guys]
> > > 
> > 
> > [Also adding gregkh to the cc :)]
> > 
> > > > Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> > > > Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
> 
> What kernel version is this?  2.6.24 had lots of "issues" with the uids
> code, I'm amazed it worked at all :)
> 

:). Seems to be a stable series kernel (2.6.24.3). Can you please tell
me some of the issues, so that I can try to go fix it up.

thanks,
-- 
regards,
Dhaval
