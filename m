Return-Path: <linux-kernel-owner+w=401wt.eu-S1767743AbXDFPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767743AbXDFPZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767744AbXDFPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:25:04 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:39070 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767743AbXDFPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:25:03 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 11:25:03 EDT
Date: Fri, 6 Apr 2007 16:58:06 +0200
From: Harald Welte <laforge@openmoko.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: openmoko-kernel@lists.openmoko.org,
       kernel list <linux-kernel@vger.kernel.org>, patches@arm.linux.org.uk
Subject: Re: basic support for neo1973
Message-ID: <20070406145806.GB5332@prithivi.gnumonks.org>
References: <20070405084850.GA11008@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405084850.GA11008@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 10:48:50AM +0200, Pavel Machek wrote:
> This adds very basic support for fic1973 (aka gta01, aka
> openmoko). With this patch applied, I can boot the kernel and actually
> see the messages.

please coordinate with Ben Dooks.  He's the 24xx maintainer and has
already picked up a number of our changes for mainline merging in the
next merge window.

-- 
- Harald Welte <laforge@openmoko.org>          	        http://openmoko.org/
============================================================================
Software for the world's first truly open Free Software mobile phone
