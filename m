Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYCUP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYCUP0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYCUP0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:26:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38546 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYCUP0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:26:09 -0400
Date: Fri, 21 Mar 2008 16:25:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080321152555.GA14607@elte.hu>
References: <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu> <47E2C7E3.40109@goop.org> <20080321131738.GI27245@elte.hu> <20080321143533.GA32096@elte.hu> <47E3D0FE.2030508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3D0FE.2030508@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0304]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> it just crashed again, crashlog and config attached. This time it 
>> didnt need an irq flood.
>
> Hm.  I presume it happens immediately/consistently.  Is it something 
> particular about this .config?  Do other configs work for you?

it's a generic distro config this time around. It crashed on the first 
attempt.

	Ingo
