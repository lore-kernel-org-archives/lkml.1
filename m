Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZICXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZICXWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZICXWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:22:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbZICXWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:22:52 -0400
Message-ID: <4AA04FA9.3020808@zytor.com>
Date: Thu, 03 Sep 2009 16:22:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: petkovbb@googlemail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
       kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset registers
References: <20090831073429.GA26596@liondog.tnic>	<1251705011-18636-1-git-send-email-petkovbb@gmail.com>	<20090903155539.ecd64bcd.akpm@linux-foundation.org>	<4AA049F2.5000403@zytor.com> <20090903161426.cc441294.akpm@linux-foundation.org>
In-Reply-To: <20090903161426.cc441294.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 04:14 PM, Andrew Morton wrote:
> 
> <looks>
> 
> Three days ago.  linux-next is still busted.
> 
> I want my five minutes back.

x86-64 got fixed three days ago, i386 earlier today.  Didn't fix them
both at the same time due to a brainfart on my part.  :-/

	-hpa
