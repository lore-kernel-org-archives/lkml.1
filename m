Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbYBBBdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbYBBBdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYBBBdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:33:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYBBBdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R36yrzia62SeuDw/JHibhe8AUTALzNWbZSMhnK053EohROpsF9J5ruxoB9m04lBxEXmP5R0T6KzrmSW0Wdq4GF6M6YxWceC1+Zw8mvrrhRvcoi+TG9Bf8fqL2PQnVJ1aL19AvQa1mLHcdWZmGqsUXHQ4PfDFgJH6l6RYssvaqvE=
Message-ID: <6101e8c40802011733h3e5a4c8bgb6c1d1feb2205043@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:33:10 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {00/17} series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01/17** do_anonymous_page-race
02/17 invalid-semicolon
03/17 pci-fix-unterminated-pci_device_id-lists
04/17 cciss-panic-in-blk_rq_map_sg
05/17 cciss-fix_memory_leak
06/17 handle-bogus-%cs-selector-in-single-step-instruction-decoding
07/17 i386-fixup-TRACE_IRQ-breakage
08/17 intel-agp-965gme-fix
09/17 sony-laptop-call-sonypi_compat_init-earlier
10/17 via-velocity-dont-oops-on-mtu-change-1
11/17 via-velocity-dont-oops-on-mtu-change-2
12/17 nfsacl-retval.diff
13/17 nfs-fix-nfs-reval-fsid
14/17 nfs-name-len-limit
15/17 nfs-unmount-leak.patch
16/17 nfsv4-MAXNAME-fix.diff
17/17** nopage-range-fix.patch


Patch 1 and 17 not included is mainline
-- 
Thanks,
Oliver
