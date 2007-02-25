Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXBYVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXBYVCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXBYVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:02:44 -0500
Received: from ns.suse.de ([195.135.220.2]:51718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXBYVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:02:43 -0500
Date: Sun, 25 Feb 2007 12:59:42 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, Bob Tracy <rct@gherkin.frus.com>,
       Mark Brown <broonie@sirena.org.uk>,
       YOSHIFUJI Hideaki / ???????????? <yoshfuji@linux-ipv6.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       Pete Clements <clem@clem.clem-digital.net>,
       Sid Boyce <g3vbv@blueyonder.co.uk>,
       Chuck Lever <chuck.lever@oracle.com>, Andreas Schwab <schwab@suse.de>,
       Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21-rc1: known regressions (part 3)
Message-ID: <20070225205942.GA26624@kroah.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225180251.GD12392@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225180251.GD12392@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 07:02:51PM +0100, Adrian Bunk wrote:
> 
> 
> Subject    : request_module: runaway loop modprobe net-pf-1
> References : http://lkml.org/lkml/2007/2/21/206
> Submitter  : YOSHIFUJI Hideaki / ???????????? <yoshfuji@linux-ipv6.org>
> Caused-By  : Kay Sievers <kay.sievers@vrfy.org>
>              commit c353c3fb0700a3c17ea2b0237710a184232ccd7f
> Handled-By : Greg KH <greg@kroah.com>
> Status     : problem is being discussed

Patch has been reverted and submitted to Linus to pull, but he's out of
town right now...

thanks,

greg k-h
