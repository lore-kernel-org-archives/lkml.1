Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYECVKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYECVKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYECVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:10:27 -0400
Received: from www.tglx.de ([62.245.132.106]:41250 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYECVK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:10:26 -0400
Date: Sat, 3 May 2008 23:10:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: use per_cpu data
In-Reply-To: <481BA784.5050908@ct.jp.nec.com>
Message-ID: <alpine.LFD.1.10.0805032308090.6003@apollo.tec.linutronix.de>
References: <481BA784.5050908@ct.jp.nec.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> use per_cpu for per CPU data.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Applied. Thanks,

	 tglx
