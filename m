Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYHEXCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYHEXCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbYHEWzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:55:32 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56165 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbYHEWza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:55:30 -0400
Date: Tue, 5 Aug 2008 18:55:24 -0400
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access
	scanning
Message-ID: <20080805225524.GB4006@fieldses.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
> Please contact me privately or (preferably the list) for questions,
> comments, discussions, flames, names, or anything.  I'll do complete
> rewrites of the patches if someone tells me how they don't meet their
> needs or how they can be done better.  I'm here to try to bridge the
> needs (and wants) of the anti-malware vendors with the technical
> realities of the kernel.  So everyone feel free to throw in your two
> cents and I'll try to reconcile it all.  These 5 patches are part 1.
> They give us a working able solution.
> 
> >From my point of view patches forthcoming and mentioned below should
> help with performance for those who actually have userspace scanners but
> also could presents be implemented using this framework.
> 
> 
> Background
> ++++++++++
> There is a consensus in the security industry that protecting against
> malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
> of so-called on-access scanning is usable and reasonable approach.

Can you point to any helpful explanations of that concensus?

Off-hand it's surprising.  (A defense that depends on cataloging every
possible individual attack sounds difficult!)

--b.
