Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbXBMGJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbXBMGJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbXBMGJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:09:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:43439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXBMGJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:09:46 -0500
Date: Tue, 13 Feb 2007 07:09:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
Message-ID: <20070213060944.GC20644@wotan.suse.de>
References: <20070213060924.GB20644@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213060924.GB20644@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 07:09:24AM +0100, Nick Piggin wrote:
> Hi,
> 
> Just tinkering around with this and got something working, so I'll see
> if anyone else wants to try it.

(patch against 2.6.20)
