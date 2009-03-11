Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZCKEan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZCKEan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZCKEad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:30:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbZCKEac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:30:32 -0400
Date: Tue, 10 Mar 2009 21:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
Message-Id: <20090310212826.7d8b3d4e.akpm@linux-foundation.org>
In-Reply-To: <20090311003155.GB21160@buzzloop.caiaq.de>
References: <20090306160042.GA17800@buzzloop.caiaq.de>
	<20090306182432.338b0244@hyperion.delvare>
	<20090306181409.GA20135@buzzloop.caiaq.de>
	<20090307115449.32f0ab26@hyperion.delvare>
	<20090307120631.GA25276@buzzloop.caiaq.de>
	<20090307130818.367bcaad@hyperion.delvare>
	<20090309210901.GC31367@buzzloop.caiaq.de>
	<49B666F9.50209@cam.ac.uk>
	<20090310151542.GE9564@buzzloop.caiaq.de>
	<49B6A843.3090902@cam.ac.uk>
	<20090311003155.GB21160@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 01:31:55 +0100 Daniel Mack <daniel@caiaq.de> wrote:

> On Tue, Mar 10, 2009 at 05:49:55PM +0000, Jonathan Cameron wrote:
> > >>From 8ee5021834900f312ff26cd2586c18e99af31a5d Mon Sep 17 00:00:00 2001
> > > From: Daniel Mack <daniel@caiaq.de>
> > > Date: Tue, 10 Mar 2009 16:13:07 +0100
> > > Subject: [PATCH] Added driver for ISL29003 ambient light sensor
> > > 
> > > This patch adds a driver for Intersil's ISL29003 ambient light sensor
> > > device plus some documentation. Inspired by tsl2550.c, a driver for a
> > > similar device.
> > > 
> > > It is put to drivers/misc for now until the industrial I/O framework
> > > gets merged.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> 
> [...]
> 
> > All looks fine to me.
> > 
> > Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

I cannot find this review which Jonathan performed.  Fumbled
reply-to-all, or did vger break?

> Ok, wonderful :)
> 
> What's the merge path for that, who'll queue it?

I can take care of it.

Was any thought given to the CONFIG_SYSFS=n situation?
