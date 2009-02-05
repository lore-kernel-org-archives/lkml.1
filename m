Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZBEAQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZBEAQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZBEAQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:16:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZBEAQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:16:05 -0500
Message-ID: <498A2FAF.60503@zytor.com>
Date: Wed, 04 Feb 2009 16:15:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mm: introduce helper function in fault.c
References: <498A2399.4090503@ct.jp.nec.com>
In-Reply-To: <498A2399.4090503@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Introduce helper function fault_in_kernel_address() to make editors happy.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Applied to tip:x86/mm, however, I had to apply the patch manually.

	-hpa
