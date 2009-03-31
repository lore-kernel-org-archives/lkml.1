Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbZCaGF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbZCaGF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZCaGFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:05:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762107AbZCaGFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:05:05 -0400
Date: Tue, 31 Mar 2009 07:04:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] : Code cleanup for fs/inode.c as per checkpatch.pl
Message-ID: <20090331060423.GR28946@ZenIV.linux.org.uk>
References: <ea11fea30903222039r4bec470crfd9825e37a926d56@mail.gmail.com> <20090330163619.d08ba85e.akpm@linux-foundation.org> <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 08:13:56AM +0530, Manish Katiyar wrote:
> On Tue, Mar 31, 2009 at 5:06 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 23 Mar 2009 09:09:26 +0530
> > Manish Katiyar <mkatiyar@gmail.com> wrote:
> >
> >> Code cleanup for fs/inode.c as per checkpatch.pl
> >> Before:
> >> total: 24 errors, 25 warnings, 1546 lines checked
> >> After:
> >> total: 0 errors, 0 warnings, 1539 lines checked
> >
> > Probably OK, but again, please cc linux-kernel and/or linx-fsdevel.
> 
> Hi Andrew,
> 
> [ cced lkml ]

That you have.  Now, how about the patch itself? ;-)
