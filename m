Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYACXBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYACXBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYACXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:01:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45272 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYACXBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:01:01 -0500
Date: Thu, 3 Jan 2008 16:58:54 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Ben Dooks <ben@fluff.org>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, hskinnemoen@amtel.com,
       bryan.wu@analog.com, lethal@linux-sh.org
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080103165854.0d6accef@zod.rchland.ibm.com>
In-Reply-To: <20080103224139.GA4178@fluff.org.uk>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	<20080103160406.7ef5ecfe@zod.rchland.ibm.com>
	<20080103224139.GA4178@fluff.org.uk>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 22:41:40 +0000
Ben Dooks <ben@fluff.org> wrote:

> On Thu, Jan 03, 2008 at 04:04:06PM -0600, Josh Boyer wrote:
> > Rework the architecture specific Makefiles to use the in-kernel version of
> > the mkubootimg tool.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> A CC: to RMK and any other arch maintainers being touched by this
> would have useful too.

D'oh.  I thought I had fixed that in this round.  Bit late now, but
CC'd.

josh
