Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXJOS3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXJOS3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbXJOS2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:28:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38555 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbXJOS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:28:47 -0400
Date: Mon, 15 Oct 2007 20:30:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Gross <mgross@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015183017.GB23130@uranus.ravnborg.org>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015170411.GB18550@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:04:11AM -0700, Mark Gross wrote:
> On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > The kernel newbies community often gets inquiries from CS students who
> > need a project for their studies and would like to do something with
> > the Linux kernel, but would also like their code to be useful to the
> > community afterwards.
> > 
> > In order to make it easier for them, I am trying to put together a
> > page with projects that:
> > - Are self contained enough that the students can implement the
> >   project by themselves, since that is often a university requirement.
> > - Are self contained enough that Linux could merge the code (maybe
> >   with additional changes) after the student has been working on it
> >   for a few months.
> > - Are large enough to qualify as a student project, luckily there is
> >   flexibility here since we get inquiries for anything from 6 week
> >   projects to 6 month projects.
> > 
> > If you have ideas on what projects would be useful, please add them
> > to this page (or email me):
> > 
> > http://kernelnewbies.org/KernelProjects
> 
> Is there already a make config option that will do a good job at setting
> a default .config file based on what is already running on a system?  
I have discussed this briefly with Kay Sievers.
What udev can provide is the list of modules needed, so what the kernel
need to provide is a simple module to CONFIG option(s) converter + a base
config to start out with.
Nothing particular difficult but needs a few days work to do.

	Sam
