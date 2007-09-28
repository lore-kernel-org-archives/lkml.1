Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXI1QY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXI1QY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXI1QYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:24:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39094 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXI1QYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:24:47 -0400
Date: Fri, 28 Sep 2007 09:24:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use array_size macro
Message-Id: <20070928092428.cb406593.randy.dunlap@oracle.com>
In-Reply-To: <46FD1372.70608@tiscali.nl>
References: <46FCDBE9.8030406@tiscali.nl>
	<46FCDDDF.8020500@tiscali.nl>
	<20070928131514.GA5209@c2.user-mode-linux.org>
	<46FD1372.70608@tiscali.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 16:45:06 +0200 Roel Kluin wrote:

> Jeff Dike wrote:
> > On Fri, Sep 28, 2007 at 12:56:31PM +0200, Roel Kluin wrote:
> >> arch/um/kernel/tt/ptproxy/ptrace.c      |   12 ++++++------
> > 
> > I don't know what you're diffing against, but this file is history in
> >  -mm, and will be gone in mainline after 2.6.23.
> > 
> > Jeff
> > 
> Thanks for noting me. I usually pull the masters branch, so my previously submitted
> patches are against that. Apparently I have to apply the -mm patchset before sending
> patches. Is there a git branch to pull from for that?

There's a git tree for -mm.  See
http://git.kernel.org/?p=linux/kernel/git/smurf/linux-trees.git;a=summary

or use 'patch' to apply the patchset.


---
~Randy
Phaedrus says that Quality is about caring.
