Return-Path: <linux-kernel-owner+w=401wt.eu-S965760AbXCPReO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbXCPReO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965773AbXCPReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:34:13 -0400
Received: from [198.99.130.12] ([198.99.130.12]:58974 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965760AbXCPReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:34:13 -0400
Date: Fri, 16 Mar 2007 11:58:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] USER-MODE LINUX: Delete unused header file.
Message-ID: <20070316155849.GB7749@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0703101624530.27918@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703101624530.27918@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:27:30PM -0500, Robert P. J. Day wrote:
> 
>   Delete the apparently unused header file
> arch/um/kernel/tt/include/mode_kern-tt.h.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

ACK

>   this one i'm not so sure about as there is a header file named
> "mode_kern_tt.h", and those names are uncomfortably similar.

There was a renaming because I was annoyed by the mix of '-' amd '_'
in the name, but somehow I missed deleting the old file.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
