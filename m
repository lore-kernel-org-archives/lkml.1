Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbXGROts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbXGROts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXGROtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:49:41 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:48787 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXGROtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:49:40 -0400
Date: Wed, 18 Jul 2007 20:16:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070718144637.GC5337@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org> <20070718094142.GA12330@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718094142.GA12330@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, Jul 18, 2007 at 03:11:42PM +0530, Dhaval Giani wrote:
> On Wed, Jul 18, 2007 at 01:07:00AM -0700, Andrew Morton wrote:
> > On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >  
> In the meantime I will go and check if it was there in 2.6.22-rc4-mm2
> 

It is hanging with 2.6.22-rc4-mm2 as well as on the latest git on
kernel.org (2.6.22-git10).

I will get back to you with more information as soon as I have it.

Thanks

-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
