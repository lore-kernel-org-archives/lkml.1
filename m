Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbZABJ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbZABJ1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZABJ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:27:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbZABJ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:27:11 -0500
Date: Fri, 2 Jan 2009 10:26:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Subject: [PATCH] Documentation/x86/boot.txt:payload length was
	changed to payload_length
Message-ID: <20090102092659.GC1975@elte.hu>
References: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Baodong Chen <chenbdchenbd@gmail.com> wrote:

>  Documentation/x86/boot.txt:payload length was changed to payload_length
> 
> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> 
> ---
>  Documentation/x86/boot.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

looks good but the patch was whitespace damaged (all tabs were spaces and 
there were linewraps as well), please check 
Documentation/email-clients.txt and resend the patch. Thanks,

	Ingo
