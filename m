Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYADIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYADIjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbYADIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:39:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYADIi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:38:59 -0500
Date: Fri, 4 Jan 2008 09:38:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [17/20] x86: Remove explicit C3 TSC check on 64bit
Message-ID: <20080104083842.GB26921@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005013.2060014D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005013.2060014D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Trust the ACPI code to disable TSC instead when C3 is used.

thanks, applied.

	Ingo
