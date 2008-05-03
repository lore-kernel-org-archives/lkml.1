Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYECVLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYECVLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYECVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:11:29 -0400
Received: from www.tglx.de ([62.245.132.106]:41293 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYECVL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:11:28 -0400
Date: Sat, 3 May 2008 23:11:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: move do_nmi() to nmi_32.c
In-Reply-To: <481BA78F.50202@ct.jp.nec.com>
Message-ID: <alpine.LFD.1.10.0805032310110.6003@apollo.tec.linutronix.de>
References: <481BA78F.50202@ct.jp.nec.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> on x86_64 do_nmi() is in nmi_64.c.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---

Applied. Are you targeting to merge the 32/64 nmi code eventually ?

Thanks,

	tglx
