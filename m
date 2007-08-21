Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbXHUPsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbXHUPsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758859AbXHUPry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:47:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbXHUPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:47:53 -0400
Date: Tue, 21 Aug 2007 16:47:50 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Message-ID: <20070821154750.GC21089@ftp.linux.org.uk>
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking> <46CB0169.7090207@suse.de> <20070821151820.GB21089@ftp.linux.org.uk> <46CB034B.1070904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CB034B.1070904@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:22:51PM +0400, Alexey Starikovskiy wrote:
> Yes, that is the proper solution with a single drawback:
> it touches ACPICA dual-licensed code and would take ages to commit,
> and Len would probably ask you to give permission to re-license it under
> BSD.

The latter is certainly not a problem (assuming that it's non-trivial
enough to be copyrightable, in the first place).
