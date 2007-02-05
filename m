Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbXBEXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbXBEXYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965067AbXBEXYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:24:20 -0500
Received: from mga07.intel.com ([143.182.124.22]:30461 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965065AbXBEXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:24:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,285,1167638400"; 
   d="scan'208"; a="177543852:sNHT18378521"
Date: Mon, 5 Feb 2007 14:50:55 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, discuss@x86-64.org,
       Richard Gooch <rgooch@safe-mbox.com>
Subject: Re: [patch] mtrr: fix issues with large addresses
Message-ID: <20070205145055.A19581@unix-os.sc.intel.com>
References: <20070205171959.GF8665@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070205171959.GF8665@alberich.amd.com>; from andreas.herrmann3@amd.com on Mon, Feb 05, 2007 at 06:19:59PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 06:19:59PM +0100, Andreas Herrmann wrote:
> o added check to restrict base address to 36 bit on i386

Why is this? It can go upto implemented physical bits, right?

thanks,
suresh
