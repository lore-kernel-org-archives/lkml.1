Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZBFCsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZBFCsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZBFCsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:48:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZBFCsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:48:05 -0500
Date: Thu, 5 Feb 2009 18:47:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bryan Wu <cooloney@kernel.org>, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       vapier.adi@gmail.com
Subject: Re: [PATCH 1/5] Blackfin SPI Driver: use bfin_spi_ prefix on all
 functions
Message-Id: <20090205184735.f82c8bc3.akpm@linux-foundation.org>
In-Reply-To: <20090206133436.199d9282.sfr@canb.auug.org.au>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-2-git-send-email-cooloney@kernel.org>
	<20090205141245.2945141e.akpm@linux-foundation.org>
	<20090206133436.199d9282.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 13:34:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Thu, 5 Feb 2009 14:12:45 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > As usual, the driver core guys have gone trompling all over other people's code
> > and your patch doesn't apply to linux-next.
> > 
> > 11 out of 61 hunks FAILED -- saving rejects to file drivers/spi/spi_bfin5xx.c.rej
> 
> To be fair

no, they don't deserve it!  They just got lucky this time ;)

>, next-20090206 has one patch to that file it is a single hunk
> and only affects 2 lines and the patch was cc'd to the spi folks (I can't
> easily tell when as the driver-core stuff (being a quilt tree) gets
> rebased often).

yup.
