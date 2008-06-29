Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbYF2FtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbYF2FtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYF2Fsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:48:53 -0400
Received: from [76.245.85.235] ([76.245.85.235]:55731 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYF2Fsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:48:52 -0400
Date: Sat, 28 Jun 2008 21:57:50 -0700
From: Brad Boyer <flar@allandria.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
Message-ID: <20080629045750.GA28360@cynthia.pants.nu>
References: <20080625162536.GH10285@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625162536.GH10285@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 07:25:36PM +0300, Adrian Bunk wrote:
> It seems the driver was removed back in kernel 2.3 but the options were 
> forgotten.

I believe the MAC_SCC option is for another driver that got removed. I
hope to eventually bring back support for the hardware by adding m68k
mac support to PMAC_ZILOG.

	Brad Boyer
	flar@allandria.com

