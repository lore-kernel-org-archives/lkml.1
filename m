Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbZJISkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbZJISkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbZJISkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:40:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbZJISjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:39:54 -0400
Date: Fri, 9 Oct 2009 14:39:14 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the parisc tree with Linus' tree
Message-ID: <20091009183914.GG11702@bombadil.infradead.org>
References: <20091009112158.7d37ed23.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009112158.7d37ed23.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:21:58AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the parisc tree got conflicts in
> arch/parisc/include/asm/thread_info.h and arch/parisc/kernel/entry.S
> between commit d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
> TIF_NOTIFY_RESUME to (almost) all architectures [try #6]") from Linus'
> tree and commit 9f4259771faf1ffd99888796d925adae4c93630b ("parisc: add
> TIF_NOTIFY_RESUME and use tracehook_notify_resume") from the parisc tree.
> 
> It looks like the parisc tree version is a superset of the version in
> Linus' tree (for parisc).  I fixed it up (hopefully - using the parisc
> tree versions) and can carry the fix for a while.

Sorry, forgot to push out a new #next. Should be sorted now.

Thanks for the heads up.
 - Kyle
