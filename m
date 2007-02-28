Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXB1VjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXB1VjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXB1VjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:39:21 -0500
Received: from mail.velocity.net ([66.211.211.55]:38025 "EHLO
	mail.velocity.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbXB1VjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:39:20 -0500
X-AV-Checked: Wed Feb 28 16:39:19 2007 clean
Subject: Re: sata_sil problems with recent kernels
From: Dale Blount <linux-kernel@dale.us>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
In-Reply-To: <1172602444.5420.17.camel@dale.velocity.net>
References: <1172250027.15179.16.camel@dale.velocity.net>
	 <1172602444.5420.17.camel@dale.velocity.net>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 16:39:18 -0500
Message-Id: <1172698758.30931.18.camel@dale.velocity.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 13:54 -0500, Dale Blount wrote:
> On Fri, 2007-02-23 at 12:00 -0500, Dale Blount wrote:
> > Hi,
> > 
> > Excuse me if this has been covered or fixed, I couldn't find anything in
> > the archives.
> > 
> > I upgraded from 2.6.11.7 to 2.6.20.1 today and found all the drives
> > connected to 2 brands of sata_sil sata controllers not working.  The
> > drives are also (now) of various brands, Maxtor 300GB and 500GB
> > Seagates.

For the archives, the fix is documented here:

http://article.gmane.org/gmane.linux.ide/16304

Dale

