Return-Path: <linux-kernel-owner+w=401wt.eu-S1764385AbYBOJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764385AbYBOJK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYBOJKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:10:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYBOJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:10:34 -0500
Date: Fri, 15 Feb 2008 01:09:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall
 (v8)
Message-Id: <20080215010951.163fe10e.akpm@linux-foundation.org>
In-Reply-To: <20080215090120.GA6266@infradead.org>
References: <20080205213616.343721693@szeredi.hu>
	<20080214222103.a5d8f4fe.akpm@linux-foundation.org>
	<20080215090120.GA6266@infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 04:01:20 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 14, 2008 at 10:21:03PM -0800, Andrew Morton wrote:
> > Linus has just merged all the VFS renaming patches, so the decks
> > are clear for looking at this work.
> > 
> > However David and Christoph are beavering away on the r-o-bind-mounts
> > patches and I expect that there will be overlaps with unprivileged mounts.
> > 
> > Could we coordinate things a bit please?  Decide who goes first, review
> > and maybe even test each others work, etc?
> 
> Al is setting up a git tree for VFS work.  per-mount r/o will go in
> as one of the first things, aswell as his rework of the path lookup
> logic to fix the intents mess.
> 

That didn't answer my question..
