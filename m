Return-Path: <linux-kernel-owner+w=401wt.eu-S1763105AbYBSJrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105AbYBSJrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBSJrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:47:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbYBSJrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:47:06 -0500
Date: Tue, 19 Feb 2008 10:46:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in
	kernel and pcspkr driver
Message-ID: <20080219094646.GD7628@elte.hu>
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
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


* David P. Reed <dpreed@reed.com> wrote:

> x86: use explicit timing delay for pit accesses in kernel and pcspkr 
> driver

thanks, applied.

	Ingo
