Return-Path: <linux-kernel-owner+w=401wt.eu-S1946000AbXBIBoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946000AbXBIBoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946001AbXBIBoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:44:09 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946000AbXBIBoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:44:08 -0500
Message-ID: <45CBD1C6.1020403@zytor.com>
Date: Thu, 08 Feb 2007 17:43:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Andi Kleen <ak@muc.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Use correct macros in raid code, not raw asm
References: <1167348861.30506.46.camel@localhost.localdomain>	<20061228155659.462eaa9c.akpm@osdl.org>	<1167350803.30506.49.camel@localhost.localdomain>	<20061229111355.GA82929@muc.de>	<45CBCC72.6080409@zytor.com> <17867.53342.333989.501336@notabene.brown>
In-Reply-To: <17867.53342.333989.501336@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> 
> So does this look right (no, I haven't compiled it yet)
> 

No, the whole raid6_*_save_t should be removed.  I'll try to have a 
patch for you later.

	-hpa
