Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbYBZPQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbYBZPQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbYBZPQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:16:18 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47241 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733AbYBZPQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:16:16 -0500
Date: Tue, 26 Feb 2008 17:15:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] Linux 2.6.25-rc3 - various unexported
	functions () on powerpc
Message-ID: <20080226151512.GA10717@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org> <47C42234.6060906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C42234.6060906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:59:08PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The 2.6.25-rc3 kernel build fails on powerpc with allyesconfig config option,
> the .config has been attached.
>...

Builds fine here.

Local problem (e.g. disk full) on your machine?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

