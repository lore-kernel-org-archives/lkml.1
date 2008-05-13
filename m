Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYEMMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYEMMmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYEMMmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:42:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbYEMMmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:42:44 -0400
Date: Tue, 13 May 2008 14:42:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: janitor work in video-vga.c
Message-ID: <20080513124228.GE14973@elte.hu>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
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


* Miklos Vajna <vmiklos@frugalware.org> wrote:

> Just moved an open brace to the previous line.

applied, thanks.

	Ingo
