Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYGUPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYGUPxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYGUPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:53:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYGUPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:53:09 -0400
Date: Mon, 21 Jul 2008 17:52:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>,
       Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 0/4] Second batch of fastboot patches: get rid of the 2
	second rootfs delay
Message-ID: <20080721155249.GA9607@elte.hu>
References: <20080720151436.26bdc717@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720151436.26bdc717@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> this second batch of fastboot patches gets rid of the delay you can 
> get when you're not using an initrd; on my system this delay is a full 
> 2 seconds (which is longer than the whole kernel boot combined).
> 
> I've also stuck the patch series into a git tree
> 
> clone git://git.kernel.org/pub/scm/linux/git/arjan/linux-2.6-fastboot

thanks, pulled into tip/fastboot - works great here!

	Ingo
