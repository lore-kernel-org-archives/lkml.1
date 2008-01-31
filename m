Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbYAaWkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbYAaWkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYAaWjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:39:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYAaWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:39:54 -0500
Date: Thu, 31 Jan 2008 23:39:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11] fix 25 section mismatch warnings..
Message-ID: <20080131223936.GA24974@elte.hu>
References: <20080131220430.GA4874@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

>       x86: fix section mismatch warning in acpi/boot.c
>       x86: silence section mismatch warning in smpboot_64.c
>       x86: fix section mismatch warning in kernel/pci-calgary
>       x86: fix section mismatch warnings when referencing notifiers

thanks Sam, i've applied your 4 x86 related fixes to x86.git.

	Ingo
