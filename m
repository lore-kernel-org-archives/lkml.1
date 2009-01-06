Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZAFMfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZAFMfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZAFMex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:34:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZAFMex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:34:53 -0500
Date: Tue, 6 Jan 2009 13:34:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86: remove duplicated #include's
Message-ID: <20090106123441.GD10319@elte.hu>
References: <20090106065718.52C8.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106065718.52C8.WEIYI.HUANG@gmail.com>
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


* Huang Weiyi <weiyi.huang@gmail.com> wrote:

> Removed duplicated #include's in
>   arch/x86/kernel/mpparse.c
>   arch/x86/kernel/nmi.c
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

applied to tip/x86/cleanups, thanks,

	Ingo
