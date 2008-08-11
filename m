Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYHKSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYHKSpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYHKSpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:45:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59954 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYHKSpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:45:23 -0400
Date: Mon, 11 Aug 2008 21:43:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080811184341.GA1880@cs181140183.pp.htv.fi>
References: <20080811155158.GA21292@cs181140183.pp.htv.fi> <20080811165644.B18F04DE6@hiauly1.hia.nrc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080811165644.B18F04DE6@hiauly1.hia.nrc.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:56:43PM -0400, John David Anglin wrote:
> > The toplevel COPYING file of the kernel sources contains the exact 
> > licence text for all files (including binfmt_som.c) in the kernel.
> 
> The COPYING file contains the license text but it doesn't say clearly
> what the license applies to.  The closest thing to this is the statement
> 
>    Also note that the GPL below is copyrighted by the Free Software
>    Foundation, but the instance of code that it refers to (the Linux
>    kernel) is copyrighted by me and others who actually wrote it.
> 
> in the COPYING file.  The applicability of the GPL is parenthetical.
> The HOWTO file is more specific, but a clear license statement at the
> top level of the "source" tree is missing.

There's a file named COPYING at the top level, and a file named README 
at the top level that says:

WHAT IS LINUX?
...
  It is distributed under the GNU General Public License - see the
  accompanying COPYING file for more details. 


The GPLv2 licence on the Linux kernel is generally agreed upon 
(whether one likes it or not is a different question, but all 
contributors are aware that it applies) and has even been successfully 
enforced at court, which makes your attempts of finding a way to 
possibly interpret it differently kinda strange.


> Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

