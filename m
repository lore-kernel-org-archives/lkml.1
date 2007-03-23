Return-Path: <linux-kernel-owner+w=401wt.eu-S1422770AbXCWKKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770AbXCWKKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXCWKKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:10:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:33556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXCWKKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:10:43 -0400
Date: Fri, 23 Mar 2007 11:10:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323101042.GD11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323100418.GA30740@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Implement queued spinlocks for i386. [...]
> 
> isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
> but it might be a worry for the rest of the world ;-)

I never thought a FIFO queue would be patentable.

Do you have a reference to the patent number?
