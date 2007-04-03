Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXDDAaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXDDAaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXDDAaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:30:13 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:51335
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXDDAaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:30:12 -0400
Date: Tue, 3 Apr 2007 15:14:41 -0700
From: Brad Boyer <flar@allandria.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070403221441.GB13210@cynthia.pants.nu>
References: <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403.170212.02298297.davem@davemloft.net> <1175645568.10567.42.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175645568.10567.42.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 08:12:48PM -0400, David Woodhouse wrote:
> On Tue, 2007-04-03 at 17:02 -0700, David Miller wrote:
> > Sparc does the same thing, it's a common convention and you really
> > should not break it.
> 
> I thought that argument was lost many years ago. It _used_ to be a
> common convention; we got better.

This argument was made and lost as you say. The problem is that the
resolution was a decision from on high. For the most part, everyone
kept their original opinion and nothing was truly resolved. I think
there was some resentment on the part of the losing side because
they felt their opinions weren't seriously considered. Please
correct me if my impressions of that were wrong. I was not directly
involved in such arguments at the time.

	Brad Boyer
	flar@allandria.com

