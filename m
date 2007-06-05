Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXFEWfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXFEWfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbXFEWfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:35:05 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8217 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758215AbXFEWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:35:04 -0400
Subject: Re: [-mm patch] kernel/lockdep_proc.c: make 2 functions static
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070605215100.GK5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	 <20070605215100.GK5500@stusta.de>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 00:34:50 +0200
Message-Id: <1181082890.5676.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 23:51 +0200, Adrian Bunk wrote:
> On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc2-mm1:
> >...
> > +lockstat-human-readability-tweaks.patch
> >...
> >  lockstat-via-lockdep
> >...
> 
> This patch makes two needlessly global functions static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


