Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZBXRzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZBXRzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZBXRzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:55:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZBXRze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:55:34 -0500
Date: Tue, 24 Feb 2009 18:55:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jirislaby@gmail.com
Cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86_32: summit_32, use BAD_APICID
Message-ID: <20090224175518.GA15616@elte.hu>
References: <1235497095-4896-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235497095-4896-1-git-send-email-jirislaby@gmail.com>
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


* jirislaby@gmail.com <jirislaby@gmail.com> wrote:

> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Use BAD_APICID instead of 0xFF constants in summit_cpu_mask_to_apicid.
> 
> Also remove bogus comments about what we actually return.

Hm, please send x86 patches against the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

the Summit code moved to another position in the tree so your 
patches dont apply anymore.

	Ingo
