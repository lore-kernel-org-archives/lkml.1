Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYJYN63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYJYN63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 09:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYJYN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 09:58:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJYN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 09:58:20 -0400
Date: Sat, 25 Oct 2008 14:58:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081025135817.GL28946@ZenIV.linux.org.uk>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 12:50:09AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> The following is an approximate list of commits left in linux-next
> relative to 2.6.28-rc1.  Some things here may have been included in
> Linus' tree in a slightly different form.  The kvm tree is excluded from
> this list because the bits of it submitted to Linus are often different
> to what is in linux-next (my scipt says that it has ~1400 outstanding
> commits).

vfs tree in next should be empty now (for-next == for-linus, which is
merged).
