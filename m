Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYBESSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYBESSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYBESRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:17:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYBESRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:17:42 -0500
Date: Tue, 5 Feb 2008 10:17:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Guenter Kukkukk <linux@kukkukk.com>, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-Id: <20080205101702.361eb0e1.akpm@linux-foundation.org>
In-Reply-To: <20080205063114.7d7fc684@tleilax.poochiereds.net>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
	<20080130174103.17ff8197@tleilax.poochiereds.net>
	<20080205001805.0ea014f3.akpm@linux-foundation.org>
	<20080205063114.7d7fc684@tleilax.poochiereds.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 06:31:14 -0500 Jeff Layton <jlayton@redhat.com> wrote:

> > It looks like it's time?  If so, what should I set the date to?
> 
> Looks good to me. I'd suggest that we change the printk's to refer to a
> release version and state that it will be removed in for 2.6.26 (or
> 2.6.27 if that's not enough notice). Then, once the previous version is
> released, remove it from the tree as soon as possible.

OK.  smbfs is not exactly hurting us being there so I made it "will be
removed from the 2.6.27 kernel".  That gives the public the full
2.6.25->2.6.26 time period in which to discover what we're proposing and to
make any objections.
