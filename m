Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYE0Ppf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYE0Ppf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYE0Pp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:45:27 -0400
Received: from www.tglx.de ([62.245.132.106]:53805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357AbYE0Pp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:45:26 -0400
Date: Tue, 27 May 2008 17:44:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
In-Reply-To: <200805251000.10205.yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Yinghai Lu wrote:
> 
> remove extra -1 in reseve_early calling
>     panic if can not find space for new RAMDISK
> 

Thanks, applied on top of the v2 update

	tglx
