Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbYBOGVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbYBOGVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761792AbYBOGVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:21:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759541AbYBOGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:21:34 -0500
Date: Thu, 14 Feb 2008 22:21:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall
 (v8)
Message-Id: <20080214222103.a5d8f4fe.akpm@linux-foundation.org>
In-Reply-To: <20080205213616.343721693@szeredi.hu>
References: <20080205213616.343721693@szeredi.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 22:36:16 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Just documentation updates, compared to the previous submission.
> Thanks to Serge for the relentless reviews :)
> 
> Please consider for -mm, and then for 2.6.26.

Linus has just merged all the VFS renaming patches, so the decks
are clear for looking at this work.

However David and Christoph are beavering away on the r-o-bind-mounts
patches and I expect that there will be overlaps with unprivileged mounts.

Could we coordinate things a bit please?  Decide who goes first, review
and maybe even test each others work, etc?

Thanks.
