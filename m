Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbYLVA3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbYLVA3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 19:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYLVA3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 19:29:31 -0500
Received: from ozlabs.org ([203.10.76.45]:44198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbYLVA3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 19:29:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix lguest used_vectors breakage
Date: Mon, 22 Dec 2008 10:59:22 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <494B8790.4060801@kernel.org> <20081219222349.GA10954@elte.hu>
In-Reply-To: <20081219222349.GA10954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812221059.22891.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 08:53:49 Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Impact: fix and clean up
> 
> i tidied the changelog up - see it attached further below. Also Cc:-ed 
> Rusty as the motivation is to fix and standardize lguest's irq vector 
> allocation method.

Seems straightforward.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
