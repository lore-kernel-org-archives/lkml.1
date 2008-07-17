Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbYGQXXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbYGQXXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbYGQXXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:23:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbYGQXXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:23:22 -0400
Date: Fri, 18 Jul 2008 01:23:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: empty smpcommon_32.c
Message-ID: <20080717232311.GA2065@elte.hu>
References: <86802c440807171618hdecfe4cyebba5bd65d28d894@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807171618hdecfe4cyebba5bd65d28d894@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2486]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> it is renamed to smpcommon.c
> 
> but old one with one blank line still sit the tree.

thanks, zapped it.

	Ingo
