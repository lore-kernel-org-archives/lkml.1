Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbXEXXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbXEXXxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEXXxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:53:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXEXXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:53:47 -0400
Message-ID: <46562582.8060004@zytor.com>
Date: Thu, 24 May 2007 16:53:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com>	<20070524150223.41063046.akpm@linux-foundation.org>	<46560E4F.2080009@zytor.com>	<20070524224154.GA29337@redhat.com> <20070525005025.236d2483@the-village.bc.nu>
In-Reply-To: <20070525005025.236d2483@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> The older AMD docs (CPU rev guide) list bit 31 of both 0x80000001 and
> 0x00000001 as 3dnow
> 
> All their example code/docs say to use 0x80000001 
> 

I don't have access to any AM2 systems, but the bit is definitely set on
socket 939 Athlon X2 ("model 43").

	-hpa
