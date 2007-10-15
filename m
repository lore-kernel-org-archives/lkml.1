Return-Path: <linux-kernel-owner+w=401wt.eu-S934004AbXJOStk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbXJOStk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXJOSpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:45:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:25788 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934849AbXJOSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:45:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,278,1188802800"; 
   d="scan'208";a="299135349"
Date: Mon, 15 Oct 2007 11:45:09 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015184509.GA18821@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com> <20071015183017.GB23130@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015183017.GB23130@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 08:30:17PM +0200, Sam Ravnborg wrote:
> On Mon, Oct 15, 2007 at 10:04:11AM -0700, Mark Gross wrote:
> > On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > > The kernel newbies community often gets inquiries from CS students who
> > > need a project for their studies and would like to do something with
> > > the Linux kernel, but would also like their code to be useful to the
> > > community afterwards.
> > > 
> > > In order to make it easier for them, I am trying to put together a
> > > page with projects that:
> > > - Are self contained enough that the students can implement the
> > >   project by themselves, since that is often a university requirement.
> > > - Are self contained enough that Linux could merge the code (maybe
> > >   with additional changes) after the student has been working on it
> > >   for a few months.
> > > - Are large enough to qualify as a student project, luckily there is
> > >   flexibility here since we get inquiries for anything from 6 week
> > >   projects to 6 month projects.
> > > 
> > > If you have ideas on what projects would be useful, please add them
> > > to this page (or email me):
> > > 
> > > http://kernelnewbies.org/KernelProjects
> > 
> > Is there already a make config option that will do a good job at setting
> > a default .config file based on what is already running on a system?  
> I have discussed this briefly with Kay Sievers.
> What udev can provide is the list of modules needed, so what the kernel
> need to provide is a simple module to CONFIG option(s) converter + a base
> config to start out with.
> Nothing particular difficult but needs a few days work to do.
> 

that would be cool.

--mgross
