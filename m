Return-Path: <linux-kernel-owner+w=401wt.eu-S2992858AbXCIBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992858AbXCIBMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992852AbXCIBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:12:20 -0500
Received: from terminus.zytor.com ([192.83.249.54]:51465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992858AbXCIBMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:12:17 -0500
Message-ID: <45F0B45C.9060706@zytor.com>
Date: Thu, 08 Mar 2007 17:11:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: update 'getting sparse' info.
References: <20070309004526.GA17459@redhat.com>
In-Reply-To: <20070309004526.GA17459@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't put non-kernel software in /pub/linux/kernel and 
/pub/scm/linux/kernel on kernel.org.

IN PARTICULAR, if Josh is the new sparse maintainer, please contact 
ftpadmin@kernel.org so we can either create a group or simply chown the 
standard locations (/pub/software/devel/sparse, /pub/scm/devel/sparse) 
to him instead of leaving stale stuff where people can find it!

Dave Jones wrote:
> - point to the sparse webpage
> - use git:// instead of rsync://
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Nacked-by: H. Peter Anvin <hpa@kernel.org>

	-hpa
