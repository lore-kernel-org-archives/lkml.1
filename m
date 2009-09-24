Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZIXVqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZIXVqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZIXVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:46:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbZIXVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:46:34 -0400
Date: Thu, 24 Sep 2009 14:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] MAINTAINERS cleanups
Message-Id: <20090924144556.e743a5df.akpm@linux-foundation.org>
In-Reply-To: <1253819538.1806.16.camel@Joe-Laptop.home>
References: <cover.1253817463.git.joe@perches.com>
	<20090924205902.48b217fc@infradead.org>
	<1253819538.1806.16.camel@Joe-Laptop.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 12:12:18 -0700
Joe Perches <joe@perches.com> wrote:

> On Thu, 2009-09-24 at 20:59 +0200, Arjan van de Ven wrote:
> > On Thu, 24 Sep 2009 11:41:48 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > Yet another collection of MAINTAINERS cleanups
> > since all of this is to one file.. could you just make one big rollup
> > patch?
> 
> Sure, but individual patches to MAINTAINERS are better.
> 
> MAINTAINERS changes pretty quickly and the larger the patch,
> the more likely it won't apply correctly at any point in the
> future.

Yup, nanopatches to MAITNAINERS are much preferred, please.  It's
a rather high contention point!

