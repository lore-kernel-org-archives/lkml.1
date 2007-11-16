Return-Path: <linux-kernel-owner+w=401wt.eu-S1765213AbXKPS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765213AbXKPS44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934422AbXKPSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:55:52 -0500
Received: from koto.vergenet.net ([210.128.90.7]:39725 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934411AbXKPSzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:55:51 -0500
Date: Fri, 16 Nov 2007 10:55:48 -0800
From: Simon Horman <horms@verge.net.au>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: Re: [PATCH 3/5] Add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
Message-ID: <20071116185544.GC8971@verge.net.au>
References: <473CFE14.3010400@mxs.nes.nec.co.jp> <473D016A.7010107@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D016A.7010107@mxs.nes.nec.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:33:14AM +0900, Ken'ichi Ohmichi wrote:
> 
> For readability, all the calls to vmcoreinfo_append_str() are changed to macros
> having a prefix "VMCOREINFO_".
> 
> This discussion is the following:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html
> 
> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

Acked-by: Simon Horman <horms@verge.net.au>
