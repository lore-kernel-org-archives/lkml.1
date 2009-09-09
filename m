Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZIIDnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZIIDnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIIDnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:43:40 -0400
Received: from fifo99.com ([67.223.236.141]:51760 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZIIDnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:43:40 -0400
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch
 init_task.c files.
From: Daniel Walker <dwalker@fifo99.com>
To: Joe Perches <joe@perches.com>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1252467119.28130.21.camel@Joe-Laptop.home>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
	 <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
	 <1252465099.14793.49.camel@desktop>
	 <1252465417.28130.3.camel@Joe-Laptop.home>
	 <1252465625.14793.52.camel@desktop>
	 <1252465802.28130.9.camel@Joe-Laptop.home>
	 <1252466482.14793.60.camel@desktop>
	 <1252467119.28130.21.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 20:44:02 -0700
Message-Id: <1252467842.14793.66.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 20:31 -0700, Joe Perches wrote:
> On Tue, 2009-09-08 at 20:21 -0700, Daniel Walker wrote:
> > On Tue, 2009-09-08 at 20:10 -0700, Joe Perches wrote:
> > > Shrug.  So submit a patch...
> > I would if this was code in the kernel already, but it's not. LKML
> > submission is the process people use to find these types of issues.
> > Issues that should be fixed prior to inclusion, and may have been
> > overlooked..
> 
> I think you should look at the patch again, and
> perhaps not react what appears perhaps mindlessly.
> 

It does little good to argue with me.. Ultimately your "clean up" isn't
clean, and that makes it not such a good choice for mainline inclusion. 

Daniel

