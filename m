Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYDBGQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYDBGQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYDBGP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:15:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbYDBGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:15:58 -0400
Date: Tue, 1 Apr 2008 23:15:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1
Message-Id: <20080401231556.c6b87487.akpm@linux-foundation.org>
In-Reply-To: <4893.1207116257@turing-police.cc.vt.edu>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<4893.1207116257@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 02:04:17 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> 
> Dell Latitude D820, Core2 T7200, x86_64.
> 
> Built my usual .config cleanly, booted OK, has gone for a half hour
> of fairly representative usage without any oopsen or other dmesg surprises...
> 

Yes, it passed testing on my six test machines without any runtime problems
at all.  Weird.

Lots of compile-time problems, but that's usual.
