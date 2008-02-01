Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbYBALQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbYBALQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYBALQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:16:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbYBALQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:16:19 -0500
Date: Fri, 1 Feb 2008 12:16:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kill misleading comments in trampoline_*.S
Message-ID: <20080201111610.GJ27178@elte.hu>
References: <20080201005429.GA5085@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201005429.GA5085@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Both trampolines actually *do* set up stack. (Is the "we jump into 
> compressed/head.S" comment still true?)

thanks, applied. (v2 of this patch)

	Ingo
