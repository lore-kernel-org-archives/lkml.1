Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYGSAon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYGSAon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYGSAof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:44:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYGSAoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:44:34 -0400
Message-ID: <488138D9.1030402@zytor.com>
Date: Fri, 18 Jul 2008 17:44:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove arch_get_ram_range
References: <200807181728.40588.yhlu.kernel@gmail.com>
In-Reply-To: <200807181728.40588.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> no user now
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Applied to tip:x86/cleanups; will push after compile test finishes.

	-hpa
