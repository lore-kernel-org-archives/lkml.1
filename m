Return-Path: <linux-kernel-owner+w=401wt.eu-S1765725AbYBUUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765725AbYBUUFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYBUUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:05:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYBUUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:05:22 -0500
Message-ID: <47BDD96F.1000804@zytor.com>
Date: Thu, 21 Feb 2008 12:05:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup - use PAGE_SIZE instead of numeric	constant
 in boot code
References: <20080221195022.GA6772@cvg> <47BDD698.9000906@zytor.com> <20080221195628.GB6772@cvg> <47BDD820.2050602@zytor.com> <20080221200058.GC6772@cvg>
In-Reply-To: <20080221200058.GC6772@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Thanks Peter, my fault.
> 

No problem; this is why we do reviews :)

	-hpa
