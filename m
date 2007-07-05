Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbXGENm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbXGENm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbXGENmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:42:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100AbXGENmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:42:49 -0400
Date: Thu, 5 Jul 2007 08:39:33 -0500
From: David Teigland <teigland@redhat.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
Message-ID: <20070705133933.GA18696@redhat.com>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in> <20070705063008.GF17650@tasint.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705063008.GF17650@tasint.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 11:30:08PM -0700, Joel Becker wrote:
> On Wed, Jul 04, 2007 at 04:37:01PM +0530, Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [0/3] configfs: Miscellaneous cleanups
> > 
> > Simple cleanups for configfs (plus DLM and OCFS2, wherever applicable).
> > This is diffed against 2.6.22-rc6-mm1.
> 
> 	All three are pretty clean and useful.
> 
> > [1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
> 
> 	I thought I had this already.  If someone is using it (and
> fs/dlm obviously is), we should provide it for the general case.
> 
> > [2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
> 
> 	I've just been lazy about this one.  Thank you.
> 
> > [3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly
> 
> 	Makes sense as well.
> 
> 	Any dissent from other subsystems?  If not, expect these to
> show up in the ocfs2 tree soon-ish (I'm currently on vacation :-)

All look good from here.

Dave

