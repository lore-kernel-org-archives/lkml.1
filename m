Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYKFHRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYKFHRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYKFHR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:17:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYKFHR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:17:27 -0500
Date: Thu, 6 Nov 2008 08:17:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: mention ACPI in top-level Kconfig menu
Message-ID: <20081106071715.GJ15731@elte.hu>
References: <200811051237.28514.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811051237.28514.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Mention ACPI in the top-level menu to give a clue as to where
> it lives.  This matches what ia64 does.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

applied to tip/x86/urgent, thanks Bjorn!

small tweak:

> -menu "Power management options"
> +menu "Power management and ACPI"

i changed it to "Power management and ACPI options".

	Ingo
