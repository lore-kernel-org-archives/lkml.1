Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYG1PdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYG1PdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbYG1Pcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:32:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38566 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbYG1Pcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:32:47 -0400
Date: Mon, 28 Jul 2008 17:32:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Samuel Sieb <samuel@sieb.net>
Cc: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080728153224.GA28495@elte.hu>
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu> <200807221251.10843.jbe@pengutronix.de> <4886DB31.8070306@sieb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4886DB31.8070306@sieb.net>
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


* Samuel Sieb <samuel@sieb.net> wrote:

>> The only critical tweak I found is the one that changes the 
>> "Performance Control Incrementer" because its settings depends on the 
>> CPU's core frequency. Maybe this tweak should be removed, because the 
>> BIOS (hopefully) set it in a way the hardware supports.
>
> This was the only line that was a problem.  See the other branch of 
> this thread with Juergen Beisert.

any patch we should pick up to make your box boot?

	Ingo
