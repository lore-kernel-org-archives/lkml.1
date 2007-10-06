Return-Path: <linux-kernel-owner+w=401wt.eu-S1764689AbXJFPRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbXJFPRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbXJFPRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:17:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49163 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbXJFPRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:17:35 -0400
Date: Sat, 6 Oct 2007 11:17:34 -0400
From: Jeff Garzik <jeff@garzik.org>
To: netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] forcedeth: several proposed updates for testing
Message-ID: <20071006151734.GA17680@havoc.gtf.org>
References: <20071006151250.GA17020@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006151250.GA17020@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 11:12:50AM -0400, Jeff Garzik wrote:
> 
> The 'fe-lock' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git fe-lock


It should also be pointed out that these patches were generated on top
of davem's net-2.6.24.git tree.

They -probably- apply to -mm, but you might have to remove the forcedeth
patches -mm already has, before applying.


