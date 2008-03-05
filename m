Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYCEPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYCEPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbYCEPs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:48:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977AbYCEPs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:48:27 -0500
Date: Wed, 5 Mar 2008 16:48:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/kernel/cpu/feature_names.c - use angle
	brackets for include
Message-ID: <20080305154804.GB22393@elte.hu>
References: <1204678020.5180.92.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204678020.5180.92.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0592]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> -#include "asm/cpufeature.h"
> +#include <asm/cpufeature.h>

thanks, applied.

	Ingo
