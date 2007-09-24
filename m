Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXIXNOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXIXNOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXIXNOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:14:36 -0400
Received: from kanga.kvack.org ([66.96.29.28]:39769 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXIXNOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:14:36 -0400
Date: Mon, 24 Sep 2007 08:43:20 -0400
From: Marcelo Tosatti <marcelo@kvack.org>
To: Jochen Friedrich <jochen@scram.de>, Paul Mackerras <paulus@samba.org>
Cc: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [PATCH0/4] Various bug fixes
Message-ID: <20070924124320.GA5648@dmt>
References: <46F6C9B0.8020200@scram.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F6C9B0.8020200@scram.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Paul, please apply.

On Sun, Sep 23, 2007 at 10:16:48PM +0200, Jochen Friedrich wrote:
> Here is a series fixing some bugs for 8xx powerpc CPUs.
> 
> 1. [POWERPC] Fix copy'n'paste typo in commproc.c
> 2. [PPC] Fix cpm_dpram_addr returning phys mem instead of virt mem
> 3. [PPC] Compile fix for 8xx CPM Ehernet driver
> 4. [POWERPC] Fix cpm_uart driver
> 
> This series can be pulled from git://git.bocc.de/dbox2.git ppc-fixes
> 
> Thanks,
> Jochen
