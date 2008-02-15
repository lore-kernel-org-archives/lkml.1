Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbYBOBK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbYBOBK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYBOBKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:10:11 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60159 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbYBOBKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:10:10 -0500
Date: Fri, 15 Feb 2008 03:09:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build status
Message-ID: <20080215010948.GL23227@cs181133002.pp.htv.fi>
References: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:42:53AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Initial status can be seen here
> http://kisskb.ellerman.id.au/kisskb/branch/9/ (I hope to make a better
> URL soon).  Suggestions for more compiler/config combinations are
> welcome, but we can't necessarily commit to fulfilling all you
> wishes.  :-)

defconfigs for _all_ architectures (like what Jan does since many years 
for all -mm and -git (and previously -bk) kernels [1]).

If you want to duplicate what Jan already does you might also want to 
copy his layout since it's very convenient to see everything on his 
page without having to scroll vertically.

cu
Adrian

[1] http://l4x.org/k/

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

