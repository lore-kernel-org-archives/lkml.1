Return-Path: <linux-kernel-owner+w=401wt.eu-S1763669AbYFWT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763669AbYFWT6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYFWT6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:58:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbYFWT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:58:07 -0400
Message-ID: <48600036.7060803@zytor.com>
Date: Mon, 23 Jun 2008 12:57:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup using max_low_pfn for 32 bit
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com> <200806230305.30944.yhlu.kernel@gmail.com> <20080623195616.GA3670@elte.hu>
In-Reply-To: <20080623195616.GA3670@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> very nice stuff - and it's working pretty well in my testing so far!
> 

Very nice stuff indeed!

	-hpa
