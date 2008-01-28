Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbYA1XNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbYA1XNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764303AbYA1XNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764296AbYA1XNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hiMuGixBMILTatvX889tPw8lk2nGqhcdLGJH3fcvGdtw8EgpDdTDa/ab9e8vz5RFyU+1mAO0VAYSKZ4coVOxM6RCpBQ86uFzX6VJeIysYZoRSYxhpASXyTz7GQ5yXIaSZhoXnHi7cHZqL67beXkfCpABdQBpS3NwBN7VWXnNKu8=
Message-ID: <6101e8c40801281513p24352c4ex6c44e79aefe77696@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:13 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {00/17} series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_anonymous_page-race
invalid-semicolon
pci-fix-unterminated-pci_device_id-lists
cciss-panic-in-blk_rq_map_sg
cciss-fix_memory_leak
handle-bogus-%cs-selector-in-single-step-instruction-decoding
i386-fixup-TRACE_IRQ-breakage
intel-agp-965gme-fix
sony-laptop-call-sonypi_compat_init-earlier
via-velocity-dont-oops-on-mtu-change-1
via-velocity-dont-oops-on-mtu-change-2
nfsacl-retval.diff
nfs-fix-nfs-reval-fsid
nfs-name-len-limit
nfs-unmount-leak.patch
nfsv4-MAXNAME-fix.diff
nopage-range-fix.patch

this patches is from suse 10.3 kernel, the most is applyied in
mainline, but 2 not.

/* allyesconfig comile tested and used in my pc with own kernel */
-- 
Thanks,
Oliver
