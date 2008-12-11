Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYLKEGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYLKEGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYLKEGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:06:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbYLKEGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:06:19 -0500
Date: Wed, 10 Dec 2008 20:06:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs trees for linux-next
Message-Id: <20081210200604.8e190b0d.akpm@linux-foundation.org>
In-Reply-To: <20081211141436.030c2d65.sfr@canb.auug.org.au>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	<1228962896.21376.11.camel@think.oraclecorp.com>
	<20081211141436.030c2d65.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 14:14:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 10 Dec 2008 21:34:56 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> >
> > Just an update, while I still have a long todo list and plenty of things
> > to fix in the code, these src trees have been updated with a disk format
> > I hope to maintain compatibility with from here on.  There are still
> > format changes planned, but should go in through the compat mechanisms
> > in the sources now.
> > 
> > The btrfs trees are still at 2.6.28-rc5, but I just tested against
> > linux-next without problems.
> 
> Do you think this is ready to be added to the end of linux-next, yet?  Or
> is this more -mm material?

I'd prefer that it go into linux-next in the usual fashion.  But the
first step is review..
