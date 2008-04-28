Return-Path: <linux-kernel-owner+w=401wt.eu-S965949AbYD1SbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965949AbYD1SbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936606AbYD1SXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:23:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936597AbYD1SXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:23:35 -0400
Date: Mon, 28 Apr 2008 20:23:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080428182323.GD1685@elte.hu>
References: <20080424144120.GA7717@cvg> <4810CC2F.3010600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4810CC2F.3010600@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Cyrill Gorcunov wrote:
>> X86_VM_MASK is a kernel specific flag so lets hide it from userland programs
>>  Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>
> Looks good to me.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>

applied, thanks.

	Ingo
