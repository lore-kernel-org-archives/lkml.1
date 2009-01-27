Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZA0W7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZA0W7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZA0W7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:59:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46669 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZA0W7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:59:13 -0500
Message-ID: <497F90F5.3070706@zytor.com>
Date: Tue, 27 Jan 2009 14:55:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Brian Gerst <brgerst@gmail.com>, L-K <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: little cleanup of cpu_init()
References: <1233088894.10992.35.camel@laptop>
In-Reply-To: <1233088894.10992.35.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> While I was looking through the new and improved bootstrap code - great
> work that, thanks! I found the below a slight improvement.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Applied to tip:x86/cleanups, thanks!  Will push after quick test.

	-hpa
