Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYBBAKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYBBAKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbYBBAKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:10:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbYBBAKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:10:44 -0500
Date: Fri, 1 Feb 2008 16:00:39 -0800
From: Greg KH <greg@kroah.com>
To: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.22.y] {00/17} series for stable kernel
Message-ID: <20080202000039.GA25722@kroah.com>
References: <6101e8c40801281513p24352c4ex6c44e79aefe77696@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40801281513p24352c4ex6c44e79aefe77696@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:13:13AM +0100, Oliver Pinter (Pint?r Oliv?r) wrote:
> do_anonymous_page-race
> invalid-semicolon
> pci-fix-unterminated-pci_device_id-lists
> cciss-panic-in-blk_rq_map_sg
> cciss-fix_memory_leak
> handle-bogus-%cs-selector-in-single-step-instruction-decoding
> i386-fixup-TRACE_IRQ-breakage
> intel-agp-965gme-fix
> sony-laptop-call-sonypi_compat_init-earlier
> via-velocity-dont-oops-on-mtu-change-1
> via-velocity-dont-oops-on-mtu-change-2
> nfsacl-retval.diff
> nfs-fix-nfs-reval-fsid
> nfs-name-len-limit
> nfs-unmount-leak.patch
> nfsv4-MAXNAME-fix.diff
> nopage-range-fix.patch
> 
> this patches is from suse 10.3 kernel, the most is applyied in
> mainline, but 2 not.

But which 2 are not?  We can't add them to the -stable tree unless they
are.

Can you resend the ones that are already upstream, with the git commit
ids?  You did that with some, but not all, and more than 2, so I really
have no idea what to apply here.

So I guess I'll drop all of these, as I really don't want to go digging
to figure it out :(

thanks,

greg k-h
