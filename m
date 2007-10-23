Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbXJWTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbXJWTP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXJWTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:15:49 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:49650 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752068AbXJWTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:15:48 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 23 Oct 2007 12:15:46 -0700
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dale Farnsworth <dale@farnsworth.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Fix fallout from sg_page changes
Message-ID: <20071023191546.GA15210@xyzzy.farnsworth.org>
References: <20071023145300.GA18989@xyzzy.farnsworth.org> <20071023184448.GE14671@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023184448.GE14671@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:44:48PM +0200, Jens Axboe wrote:
> On Tue, Oct 23 2007, Dale Farnsworth wrote:
> > 
> > Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> > ---
> >  include/asm-powerpc/dma-mapping.h |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> Should already be merged in Linus' current tree.

Yes, it is.  Thank you.

-Dale
