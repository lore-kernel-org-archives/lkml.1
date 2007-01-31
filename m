Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbXAaJOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbXAaJOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbXAaJOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:14:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbXAaJOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:14:33 -0500
Date: Wed, 31 Jan 2007 10:12:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Message-ID: <20070131091235.GA20306@elte.hu>
References: <20070125113350.GA31068@elte.hu> <20070125180324.36E8B557CF8@chen.mtu.ru> <p73ejpd96x9.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejpd96x9.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Andrey Borzenkov <arvidjaar@mail.ru> writes:
> 
> > Will it work with netconsole too? COM port is often missing in notebooks
> > today.
> 
> It will work with some luck with firescope (in the worst case you
> might need to disable suspend in ochi1394). Many laptops have firewire
> ports.
> 
> ftp://ftp.firstfloor.org/pub/ak/firescope/

wow, that's really neat!

	Ingo
