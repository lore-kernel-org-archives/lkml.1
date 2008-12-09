Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYLIIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYLIIxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYLIIxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:53:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYLIIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:53:19 -0500
Date: Tue, 9 Dec 2008 08:53:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 9
Message-ID: <20081209085317.GD28946@ZenIV.linux.org.uk>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 06:52:37PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081208:
> 
> Today's tree fails the powerpc allyesconfig build but succeeds with
> CONFIG_PROFILE_ALL_BRANCHES turned off.
> 
> New trees:
> 	audit-current
> 	audit

FWIW, I've bumped the conflicting patch out of audit/for-linus and sent
pull request for rest of that queue.  The rest will get thrown to
assorted trees, assuming that security folks are willing to host a rebased
version of [PATCH] Audit: Log TIOCSTI.
