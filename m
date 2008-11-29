Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYK2GvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYK2GvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 01:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYK2GvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 01:51:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYK2GvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 01:51:09 -0500
Date: Fri, 28 Nov 2008 22:50:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       mtk.manpages@gmail.com, dl9pf@gmx.de, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, Trivial patch monkey <trivial@kernel.org>
Subject: Re: Document hadling of bad memory
Message-Id: <20081128225032.0ddeb1b8.akpm@linux-foundation.org>
In-Reply-To: <200811280300.26969.rob@landley.net>
References: <20081126161521.GC1983@elf.ucw.cz>
	<200811280300.26969.rob@landley.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 03:00:26 -0600 Rob Landley <rob@landley.net> wrote:

> On Wednesday 26 November 2008 10:15:21 Pavel Machek wrote:
> > Document how to deal with bad memory reported with memtest.
> ...
> > +BadRAM
> > +######
> > +BadRAM is the actively developed and available as kernel-patch
> > +here:  http://rick.vanrein.org/linux/badram/
> 
> So the patch isn't worth merging, but documentation about the out-of-tree 
> patch is worth merging?
> 
> I'm not objecting, I'm just confused about to what the merge criteria are...
> 

mm..  If someone finds it useful (and I assume that at least one person
would have found it useful, hence the effort to write the patch) then
why not?

(And yeah, yeah, someone might find a .gif of a parrot useful too.  Go
do some work.)

