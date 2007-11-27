Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXK0WPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXK0WPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXK0WPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:15:08 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36822 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbXK0WPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:15:07 -0500
Date: Tue, 27 Nov 2007 23:14:55 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andreas Schwab <schwab@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
	per cpu access
Message-ID: <20071127221455.GH3406@stusta.de>
References: <20071127001407.859743255@sgi.com> <20071127001430.083503280@sgi.com> <jehcj83uir.fsf@sykes.suse.de> <Pine.LNX.4.64.0711271016500.2310@schroedinger.engr.sgi.com> <jeabozs7ou.fsf@sykes.suse.de> <Pine.LNX.4.64.0711271331240.4803@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711271331240.4803@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 01:38:02PM -0800, Christoph Lameter wrote:
>...
> Hmmm...
> 
> http://www.ohse.de/uwe/articles/gcc-attributes.html
> 
> says:
> 
> model (MODEL-NAME)
>     Found in versions: 2.8-3.4
>...

This site says at the top it used gcc versions up to 3.4, so it 
obviously can't find anything in gcc >= 4.0 ...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

