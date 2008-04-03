Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYDCOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYDCOXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYDCOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:23:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:34660 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbYDCOX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:23:28 -0400
Date: Thu, 3 Apr 2008 16:23:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] SLQB: YASA
Message-ID: <20080403142326.GA9878@wotan.suse.de>
References: <20080403072550.GC25932@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403072550.GC25932@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 09:25:50AM +0200, Nick Piggin wrote:
> Hi,
> 
> I've been playing around with slab allocators because I'm concerned about
> the directions that SLUB is going in. I've come up so far with a working
> alternative implementation, which I have called SLQB (the remaining vowels
> are crap).

Oh, hmm, I think I messed up a hunk when merging in a patch here... so
this version is going to be buggy. I'll repost another tomorrow, so
nobody try to test this yet :)

Thanks,
Nick
