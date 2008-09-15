Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYIORQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYIORQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYIORQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:16:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49502 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYIORQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:16:37 -0400
Message-ID: <48CE983C.8040709@zytor.com>
Date: Mon, 15 Sep 2008 10:15:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> could be enabled via "boot=verbose" to get more debug info
> 
> will use it to convert some printk(KERN_DEBUG ...)

This seems odd, why not just use KERN_DEBUG?

	-hpa
