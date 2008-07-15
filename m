Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYGOWqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYGOWqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYGOWqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:46:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561AbYGOWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:46:03 -0400
Date: Tue, 15 Jul 2008 15:43:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
Message-Id: <20080715154323.b7d5f14d.akpm@linux-foundation.org>
In-Reply-To: <1216161003.7981.73.camel@localhost>
References: <20080715213241.GC23331@redhat.com>
	<1216161003.7981.73.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 18:30:03 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2008-07-15 at 17:32 -0400, Jason Baron wrote:
> > -convert sunrpc debug facility
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> 
> Where the hell did this come from, what's its purpose, and WTF haven't
> you Cced linux-nfs@vger.kernel.org so that the rest of us can review it?

It's on linux-kernel.  If you don't have a linux-kernel subscription
then you should fix that.  Set up a procmail rule and do a
search-by-subject when needed.

In this case, yes, it would have been nice if Jason had cc'ed lots of
different lists and individuals on the core patch and then selectively
cc'ed lists and individuals on the per-subsystem followup patches.  But
I doubt if even 2% of patch submitters manage to do all that correctly.


