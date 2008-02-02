Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbYBBAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbYBBAyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762859AbYBBAyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:54:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:22959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbYBBAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wIXiHI1nOGxyS5LLb8qjVNjgXx5nGamR1XzThlgkEGmCFlcxC5Ggj5u6KuN/9K3lJeoZgFz4U9LT0J0bk/zBnU7bipaCG28Zj8vkNPXd7GnBZFcvrTVNY+pqoO+gmFu7JftBxwgtJH76TzNbPrtolTePRkZ9myL/c/rZFmqiVjs=
Message-ID: <6101e8c40802011654l2630ef1ewe45c0a341f2ab2af@mail.gmail.com>
Date: Sat, 2 Feb 2008 01:54:44 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [2.6.22.y] {00/17} series for stable kernel
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>
In-Reply-To: <20080202000039.GA25722@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40801281513p24352c4ex6c44e79aefe77696@mail.gmail.com>
	 <20080202000039.GA25722@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi!

then i searched the git id's and resnd the patches



On 2/2/08, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 29, 2008 at 12:13:13AM +0100, Oliver Pinter (Pint?r Oliv?r)
> wrote:
> > do_anonymous_page-race
NOT PART OF mainline - or I not find  - openSUSE patch

> > invalid-semicolon
2b02d13996fe28478e45605de9bd8bdca25718de

> > pci-fix-unterminated-pci_device_id-lists
248bdd5efca5a113cbf443a993c69e53d370236b

> > cciss-panic-in-blk_rq_map_sg
a683d652d334a546be9175b894f42dbd8e399536

> > cciss-fix_memory_leak
f2912a1223c0917a7b4e054f18086209137891ea

> > handle-bogus-%cs-selector-in-single-step-instruction-decoding 29eb51101c02df517ca64ec472d7501127ad1da8

> > i386-fixup-TRACE_IRQ-breakage
a10d9a71bafd3a283da240d2868e71346d2aef6f

> > intel-agp-965gme-fix
dde4787642ee3cb85aef80bdade04b6f8ddc3df8

> > sony-laptop-call-sonypi_compat_init-earlier
015a916fbbf105bb15f4bbfd80c3b9b2f2e0d7db

> > via-velocity-dont-oops-on-mtu-change-1
bd7b3f34198071d8bec05180530c362f1800ba46

> > via-velocity-dont-oops-on-mtu-change-2
48f6b053613b62fed7a2fe3255e5568260a8d615

> > nfsacl-retval.diff
ac8587dcb58e40dd336d99d60f852041e06cc3dd

> > nfs-fix-nfs-reval-fsid
a0356862bcbeb20acf64bc1a82d28a4c5bb957a7

> > nfs-name-len-limit
54af3bb543c071769141387a42deaaab5074da55

> > nfs-unmount-leak.patch
13ef7b69b54aa8ae4ed264d0bf41339737f8543a - in mainline from comment:
...skipping... ?!

> > nfsv4-MAXNAME-fix.diff
a16e92edcd0a2846455a30823e1bac964e743baa

> > nopage-range-fix.patch
NOT PART  OF the mainline - or I not find - original openSUSE patch

> >
> > this patches is from suse 10.3 kernel, the most is applyied in
> > mainline, but 2 not.
>
> But which 2 are not?  We can't add them to the -stable tree unless they
> are.
>
> Can you resend the ones that are already upstream, with the git commit
> ids?  You did that with some, but not all, and more than 2, so I really
> have no idea what to apply here.
>
> So I guess I'll drop all of these, as I really don't want to go digging
> to figure it out :(
>
> thanks,
>
> greg k-h
>


-- 
Thanks,
Oliver
