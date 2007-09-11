Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXIKXwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXIKXwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761452AbXIKXwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:52:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:27239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357AbXIKXv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:51:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,240,1186383600"; 
   d="scan'208";a="292964048"
Message-ID: <46E729DC.2080507@intel.com>
Date: Tue, 11 Sep 2007 16:50:52 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org
Subject: Re: + git-net-broke-ixgbe.patch added to -mm tree
References: <200709112326.l8BNQDU3002624@imap1.linux-foundation.org>
In-Reply-To: <200709112326.l8BNQDU3002624@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2007 23:50:56.0210 (UTC) FILETIME=[987CBB20:01C7F4CE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      git-net-broke-ixgbe
> has been added to the -mm tree.  Its filename is
>      git-net-broke-ixgbe.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: git-net-broke-ixgbe
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> igiveup

relax! do not dispair!

I will have a patch for ixgbe to fixup the NAPI API stuff tomorrow! This assumes 
that you have the version that I sent out last week though (v4).

It's running smoke tests right now, should be ready tomorrow.

Cheers,

Auke
