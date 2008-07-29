Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYG2E3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYG2E3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYG2E3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:29:31 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:48083 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYG2E3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:29:30 -0400
Date: Tue, 29 Jul 2008 00:29:29 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080729042929.GB11425@phobos.i.cabal.ca>
References: <20080717190502.74c238d5@bleh.bxl.tuxicoman.be> <20080719215459.GA2550@phobos.i.cabal.ca> <20080719230418.GA4263@phobos.i.cabal.ca> <20080720112345.07869299@bleh.bxl.tuxicoman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720112345.07869299@bleh.bxl.tuxicoman.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 11:23:45AM +0200, Guy Martin wrote:
> [    0.000000] FP[0] enabled: Rev 1 Model 16
> [    0.000000] The 64-bit Kernel has started...

I pushed a better fix to my git tree on kernel.org on top of
v2.6.27-rc1. Can you test that?

r, Kyle
