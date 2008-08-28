Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYH1QUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYH1QUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYH1QUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYH1QUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:20:40 -0400
Date: Thu, 28 Aug 2008 18:20:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH: Remove 8254 timer texts from Documentation
Message-ID: <20080828162026.GA2509@elte.hu>
References: <20080828110007.69674b06@doriath.conectiva> <Pine.LNX.4.55.0808281706420.15273@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0808281706420.15273@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Thu, 28 Aug 2008, Luiz Fernando N. Capitulino wrote:
> 
> > Commit ecd29476ae0143b1c3641edfa76c0fc3e9ad3021 removed the
> > "disable_8254_timer" and "enable_8254_timer" kernel parameters from
> > the kernel but did not remove the references to them from two
> > files in the Documentation directory: kernel-parameters.txt and
> > x86/x86_64/boot-options.txt.
> > 
> > This change completes the removal.
> 
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
> 
>  Thanks for spotting this -- I didn't expect these were actually
> documented. ;)

applied to tip/x86/doc - thanks!

	Ingo
