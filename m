Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZKKF7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZKKF7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 00:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZKKF7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 00:59:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:45973 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZKKF7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 00:59:35 -0500
Date: Tue, 10 Nov 2009 22:01:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, mingo@elte.hu,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
Message-ID: <20091110220106.615fa525@infradead.org>
In-Reply-To: <1257890369.4108.490.camel@laptop>
References: <20091024125853.35143117@infradead.org>
	<20091024130432.0c46ef27@infradead.org>
	<20091024130728.051c4d7c@infradead.org>
	<1256453725.12138.40.camel@marge.simson.net>
	<20091025095109.449bac9e@infradead.org>
	<1256492289.14241.40.camel@marge.simson.net>
	<20091025123319.2b76bf69@infradead.org>
	<1256508287.17306.14.camel@marge.simson.net>
	<1256522035.7356.19.camel@laptop>
	<1256531907.7117.31.camel@marge.simson.net>
	<20091025215225.05ac9ac9@infradead.org>
	<1256533734.7117.45.camel@marge.simson.net>
	<20091025223657.5ebc2857@infradead.org>
	<1257890369.4108.490.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 22:59:29 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-10-25 at 22:36 -0700, Arjan van de Ven wrote:
> > 
> > if you're a multicore domain you better have a shared cache.. that's
> > what it should mean. If it does not we should fix that.
> 
> Fully agreed.. I've been dying to do the below for ages :-)
> 

completely sane.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

