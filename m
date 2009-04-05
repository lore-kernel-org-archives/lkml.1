Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZDEUHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZDEUHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbZDEUGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:06:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbZDEUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:06:55 -0400
Message-ID: <49D90F08.3010601@zytor.com>
Date: Sun, 05 Apr 2009 13:05:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Meelis Roos <mroos@linux.ee>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange MTRR on 2.6.29-git
References: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee> <86802c440904011143i65d99bd8x7a296f616f6bfccc@mail.gmail.com> <Pine.SOC.4.64.0904050953480.2958@math.ut.ee> <20090405134109.GA24782@elte.hu>
In-Reply-To: <20090405134109.GA24782@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  
> ok, great.
> 
> I'm wondering whether CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT should be 
> 1 by default in the future.
> 

I suspect it should be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

