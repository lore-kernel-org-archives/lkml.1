Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXCYOsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXCYOsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXCYOsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:48:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34015 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbXCYOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:48:35 -0400
Date: Sun, 25 Mar 2007 16:48:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070325144838.GD16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de> <m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de> <m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de> <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com> <46065FED.8030206@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46065FED.8030206@m3y3r.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 01:41:33PM +0200, Thomas Meyer wrote:
>...
> The first suspend to disk is ok. The second suspend to disk has a
> strange behaviour:
> 1.) write pm image
> 2.) the system disable the non-boot cpus again (i guess this happens in
> power_down())
> 3.) the system doesn't power down.
> 4.) pressing any key and the system powers down.
>...

Is this also present with 2.6.20, or is it a regression?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

