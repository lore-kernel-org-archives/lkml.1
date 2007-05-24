Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXEXWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXEXWQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXEXWQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:16:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXEXWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:16:13 -0400
Message-ID: <46560EA3.6030509@zytor.com>
Date: Thu, 24 May 2007 15:16:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org> <20070524220823.GA8362@linux-os.sc.intel.com>
In-Reply-To: <20070524220823.GA8362@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> 
> Hmm.. Will move feature detection to setup routines and will also
> refresh the patch against latest mm and resend it
> 

If you could send a patch against my git.newsetup instead, I'll merge
into that tree.

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary

	-hpa

