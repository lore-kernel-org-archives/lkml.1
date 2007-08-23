Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXHWB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXHWB2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXHWB2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:28:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37011 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXHWB2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:28:11 -0400
Date: Thu, 23 Aug 2007 02:28:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Brown, Len" <len.brown@intel.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       WANG Cong <xiyou.wangcong@gmail.com>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Message-ID: <20070823012806.GG21089@ftp.linux.org.uk>
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking> <46CB0169.7090207@suse.de> <20070821151820.GB21089@ftp.linux.org.uk> <46CB034B.1070904@suse.de> <20070821154750.GC21089@ftp.linux.org.uk> <CFF307C98FEABE47A452B27C06B85BB603A760AD@hdsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CFF307C98FEABE47A452B27C06B85BB603A760AD@hdsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 08:59:48PM -0400, Brown, Len wrote:
> The dual license is at the top of the file.
> I just need to know when you touch one of these dual-license files
> that Intel has your permission to ship your change to folks we
> send the same file to under the BSD-style non-GPL license.
> eg. BSD, Solaris and HPUX uses this same ACPICA files -- though in a
> different format.

You have it.
