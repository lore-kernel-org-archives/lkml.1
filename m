Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbYEPUnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbYEPUnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYEPUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:42:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYEPUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:42:52 -0400
Date: Fri, 16 May 2008 13:42:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/3] mm: Minor clean-up of page flags in mm/page_alloc.c
 v5
In-Reply-To: <20080516192244.GD7885@sgi.com>
Message-ID: <alpine.LFD.1.10.0805161341140.2941@woody.linux-foundation.org>
References: <20080516192244.GD7885@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Russ Anderson wrote:
>
> Minor source code cleanup of page flags in mm/page_alloc.c.  
> Move the definition of the groups of bits to page-flags.h.

Ok, if you fix the comments (they are subtly wrong, probably due to 
excessive cut-and-paste), I can happily apply 1/3 regardless of any other 
issues.

		Linus
