Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYGBQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYGBQ4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYGBQ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:56:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYGBQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:56:03 -0400
Date: Wed, 2 Jul 2008 09:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       autofs@linux.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] autofs4 - detect invalid direct mount requests
Message-Id: <20080702095459.f3761ff4.akpm@linux-foundation.org>
In-Reply-To: <1215006622.3046.75.camel@raven.themaw.net>
References: <20080620051301.9988.94307.stgit@raven.themaw.net>
	<20080701141715.62a2132b.akpm@linux-foundation.org>
	<1214989192.3046.34.camel@raven.themaw.net>
	<x49tzf8pflh.fsf@segfault.boston.devel.redhat.com>
	<1215006622.3046.75.camel@raven.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 21:50:21 +0800 Ian Kent <raven@themaw.net> wrote:

> > > serious bug fixes. It gets rid of an annoyance more than anything as the
> > > daemon still has to check for it.
> > >
> > > It isn't important or urgent, just useful.
> > 
> > And I'd still like to see a comment in there!  ;)
> 
> OK.
> 
> Andrew, could you drop that patch and I'll re-submit it with a better
> change log entry.

nope ;)

Today is try-to-get-rc8-mm1-to-work day and that's likely the last
2.6.26-rcX-mmY.  We need to get everything we can runtime tested a bit.
