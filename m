Return-Path: <linux-kernel-owner+w=401wt.eu-S939300AbXHMVbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939300AbXHMVbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbXHMVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:31:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46075 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754112AbXHMVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:31:24 -0400
Date: Mon, 13 Aug 2007 23:31:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [-mm patch] kconfig syntax cleanups
Message-ID: <20070813213114.GL18945@stusta.de>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com> <20070813185431.GD18945@stusta.de> <Pine.LNX.4.64.0708131510140.14058@localhost.localdomain> <20070813200509.GF18945@stusta.de> <20070813141701.446990cb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070813141701.446990cb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:17:01PM -0700, Randy Dunlap wrote:
> On Mon, 13 Aug 2007 22:05:10 +0200 Adrian Bunk wrote:
>...
> > This patch removes the following redundant and never or rarely used 
> > kconfig syntax:
> > - "def_boolean" (same as "def_bool")
> > - "requires" (same as "depends on")
> > - "depends" (same as "depends on")
> > 
> > Most of the size of this patch comes from regenerating generated files.
> 
> Looks OK to me.
> 
> Missing S-O-B line...

Ups, sorry:

Signed-off-by: Adrian Bunk <bunk@kernel.org>

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

