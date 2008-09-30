Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYI3BfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYI3BfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYI3BfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:35:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYI3BfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:35:07 -0400
Message-ID: <48E1822F.1050406@zytor.com>
Date: Mon, 29 Sep 2008 18:34:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mtrr_cleanup safe to get more spare regs now
References: <1222720757-31124-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222720757-31124-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> don't need to break earlier, could get more optimized setting automatically

Tried it out, works great.  Added to x86/mtrr.  Thanks!

	-hpa
