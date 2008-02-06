Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYBFWyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYBFWyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbYBFWxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:53:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50994 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154AbYBFWxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:53:44 -0500
Date: Wed, 6 Feb 2008 14:48:41 -0800
From: Greg KH <greg@kroah.com>
To: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       Adrian Bunk <bunk@kernel.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [stable] [2.6.22.y] {00/17} series for stable kernel #2
Message-ID: <20080206224841.GB11045@kroah.com>
References: <6101e8c40802011733h3e5a4c8bgb6c1d1feb2205043@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802011733h3e5a4c8bgb6c1d1feb2205043@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 02:33:10AM +0100, Oliver Pinter (Pint?r Oliv?r) wrote:
> 01/17** do_anonymous_page-race
> 02/17 invalid-semicolon
> 03/17 pci-fix-unterminated-pci_device_id-lists
> 04/17 cciss-panic-in-blk_rq_map_sg
> 05/17 cciss-fix_memory_leak
> 06/17 handle-bogus-%cs-selector-in-single-step-instruction-decoding
> 07/17 i386-fixup-TRACE_IRQ-breakage
> 08/17 intel-agp-965gme-fix
> 09/17 sony-laptop-call-sonypi_compat_init-earlier
> 10/17 via-velocity-dont-oops-on-mtu-change-1
> 11/17 via-velocity-dont-oops-on-mtu-change-2
> 12/17 nfsacl-retval.diff
> 13/17 nfs-fix-nfs-reval-fsid
> 14/17 nfs-name-len-limit
> 15/17 nfs-unmount-leak.patch
> 16/17 nfsv4-MAXNAME-fix.diff
> 17/17** nopage-range-fix.patch
> 
> 
> Patch 1 and 17 not included is mainline

All of these were in base64 format and I can't apply any of them :(

Can you please resend them with a sane email client, and take out the
ones that are not upstream yet, and remove the ones that are already in
the 2.6.24.17 release?

thanks,

greg k-h
