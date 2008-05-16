Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYEPLdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYEPLdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYEPLdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:33:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbYEPLdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:33:36 -0400
Date: Fri, 16 May 2008 13:33:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove duplicate declaration of unknown_nmi_panic
Message-ID: <20080516113317.GC6444@elte.hu>
References: <1210903286.31993.4.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210903286.31993.4.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

>  extern int nmi_watchdog_enabled;
> -extern int unknown_nmi_panic;
>  extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);

applied, thanks.

	Ingo
