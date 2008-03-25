Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYCYTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYCYTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbYCYTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:18:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbYCYTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:18:39 -0400
Date: Tue, 25 Mar 2008 12:18:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: yorksun@freescale.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2 v2] Add DIU platform code for MPC8610HPCD
Message-Id: <20080325121804.a273944e.akpm@linux-foundation.org>
In-Reply-To: <20080325124322.GH12798@shadowen.org>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	<12059526274026-git-send-email-yorksun@freescale.com>
	<12059526271964-git-send-email-yorksun@freescale.com>
	<20080320153304.cdc1817d.akpm@linux-foundation.org>
	<20080325124322.GH12798@shadowen.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 12:43:22 +0000
Andy Whitcroft <apw@shadowen.org> wrote:

> > > ...
> > >
> > > +unsigned int mpc8610hpcd_get_pixel_format
> > > +	(unsigned int bits_per_pixel, int monitor_port)
> 
> This seems like it might be detectable, does this seem like something we
> should try an report?

I guess so.  It's quite unusual.
