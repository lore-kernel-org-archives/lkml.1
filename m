Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbZEAMJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbZEAMJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZEAMJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:09:14 -0400
Received: from nox.protox.org ([88.191.38.29]:48724 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbZEAMJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:09:14 -0400
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
From: Jerome Glisse <glisse@freedesktop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karsten Mehrhoff <kawime@gmx.de>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Shaohua Li <shaohua.li@intel.com>,
       Dave Airlie <airlied@linux.ie>, stable@kernel.org
In-Reply-To: <20090430175927.a89f1cd3.akpm@linux-foundation.org>
References: <op.us6ywl2jgp7xae@127.0.0.1>
	 <20090430175927.a89f1cd3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 01 May 2009 14:08:52 +0200
Message-Id: <1241179733.2606.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 10:51:47 +0200
> Karsten Mehrhoff <kawime@gmx.de> wrote:
> 
> > [1.]
> > PROBLEM: No more agp card functionality with the patch 2.6.29.2 of 'a/drivers/char/agp/generic.c'
> > 
> > [2.]
> > I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run into problems with the speed of my ATI RADEON 9600 (rv350)
> > 
> 

Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
working with this patch ? Slowdown is expected from this patch but
it should hurt too much.

Cheers,
Jerome Glisse

