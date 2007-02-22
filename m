Return-Path: <linux-kernel-owner+w=401wt.eu-S1751425AbXBVGaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbXBVGaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXBVGaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:30:22 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49182 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXBVGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:30:21 -0500
Date: Thu, 22 Feb 2007 01:28:40 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org, clameter@sgi.com
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-ID: <20070222062840.GA23838@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000810.GK13958@stusta.de> <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com> <20070220151356.GA19239@filer.fsl.cs.sunysb.edu> <20070221141944.af6001db.akpm@linux-foundation.org> <20070222020036.GE5867@filer.fsl.cs.sunysb.edu> <20070221182657.57264123.akpm@linux-foundation.org> <45DD3574.9070801@cs.helsinki.fi> <45DD35BF.9010309@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD35BF.9010309@cs.helsinki.fi>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 08:18:39AM +0200, Pekka Enberg wrote:
> Pekka Enberg wrote:
> >The ksize exports we can add later if unionfs is to be merged.
> 
> Actually, we probably don't need it after the krealloc optimizations. I 
> think we need a new unionfs patch too... :)
 
I'm for it!
 
Josef "Jeff" Sipek.

-- 
Don't drink and derive. Alcohol and algebra don't mix.
