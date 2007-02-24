Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbXBXMZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbXBXMZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXBXMZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:25:13 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41962 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXBXMZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:25:11 -0500
Date: Sat, 24 Feb 2007 12:25:05 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MIPS: Remove unreferenced _IOC_SLMASK macro in ioctl.h.
Message-ID: <20070224122505.GB17040@linux-mips.org>
References: <Pine.LNX.4.64.0702240613250.13622@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702240613250.13622@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 06:17:09AM -0500, Robert P. J. Day wrote:

>   Delete the definition of the apparently unreferenced macro
> _IOC_SLMASK.

Applied.  Thanks,

  Ralf
