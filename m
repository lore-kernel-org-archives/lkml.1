Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYBSRsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYBSRsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBSRr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:47:56 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42430 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYBSRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:47:55 -0500
Date: Tue, 19 Feb 2008 19:47:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] documentation: move spidev_fdx example to its own
	source file
Message-ID: <20080219174719.GB31955@cs181133002.pp.htv.fi>
References: <20080218162625.1b4bd079.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080218162625.1b4bd079.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:26:25PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> cc: dbrownell@users.sourceforge.net
> cc: spi-devel-general@lists.sourceforge.net
> 
> Move sample source code to its own source file so that it can be used
> easier and build-tested/check/maintained by anyone.
> 
> (Makefile changes are in a separate patch for all of Documentation/.)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/spi/spidev       |  168 -------------------------------
>  Documentation/spi/spidev_fdx.c |  158 +++++++++++++++++++++++++++++
>  2 files changed, 160 insertions(+), 166 deletions(-)
>...

Wouldn't samples/spi/spidev_fdx.c be a better place?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

