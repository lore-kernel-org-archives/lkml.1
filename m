Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbYBNWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbYBNWXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYBNWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:23:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:50047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbYBNWXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:23:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,355,1199692800"; 
   d="scan'208";a="340105042"
Message-ID: <47B4BDFD.3040605@intel.com>
Date: Thu, 14 Feb 2008 14:17:33 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, julia@diku.dk, auke-jan.h.kok@intel.com
Subject: Re: + drivers-net-e1000-use-field_sizeof.patch added to -mm tree
References: <200802142209.m1EM9cIW005486@imap1.linux-foundation.org>
In-Reply-To: <200802142209.m1EM9cIW005486@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2008 22:18:19.0973 (UTC) FILETIME=[81273F50:01C86F57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      drivers/net/e1000: Use FIELD_SIZEOF
> has been added to the -mm tree.  Its filename is
>      drivers-net-e1000-use-field_sizeof.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/


FYI Jeff already merged this (all 3 for the intel nics) in #upstream fixes as a
single patch ...

Auke
