Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbXKPSyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbXKPSyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbXKPSyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:54:16 -0500
Received: from koto.vergenet.net ([210.128.90.7]:39720 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbXKPSyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:54:15 -0500
Date: Fri, 16 Nov 2007 10:54:10 -0800
From: Simon Horman <horms@verge.net.au>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/5] Use the existing offsetof() for VMCOREINFO_OFFSET()
Message-ID: <20071116185406.GB8971@verge.net.au>
References: <473CFE14.3010400@mxs.nes.nec.co.jp> <473D0163.5070602@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D0163.5070602@mxs.nes.nec.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:33:07AM +0900, Ken'ichi Ohmichi wrote:
> 
> It is better that the existing offsetof() is used for VMCOREINFO_OFFSET().
> 
> This discussion is the following:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html
> 
> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

Acked-by: Simon Horman <horms@verge.net.au>
