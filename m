Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXLRVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXLRVEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXLRVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:03:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38512 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXLRVDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:03:53 -0500
Date: Tue, 18 Dec 2007 22:02:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Frans Pop <elendil@planet.nl>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, ak@suse.de,
       akpm@linux-foundation.org, anthony@codemonkey.ws, avi@qumranet.com,
       chrisw@sous-sol.org, ehabkost@redhat.com, hpa@zytor.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org, roland@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       virtualization@lists.linux-foundation.org, zach@vmware.com
Subject: Re: [PATCH] finish processor.h integration
Message-ID: <20071218210233.GA23855@elte.hu>
References: <1198008293639-git-send-email-gcosta@redhat.com> <E1J4jSf-00024X-GN@faramir.fjphome.nl> <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
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


* Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> On Dec 18, 2007 6:54 PM, Frans Pop <elendil@planet.nl> wrote:
> > Glauber de Oliveira Costa wrote:
> > > What's left in processor_32.h and processor_64.h cannot be cleanly
> > > integrated. However, it's just a couple of definitions. They are moved
> > > to processor.h around ifdefs, and the original files are deleted. Note
> > > that there's much less headers included in the final version.
> >
> > Either I must be missing something or this patch was corrupted somehow.
> 
> neither.
> Note the else in the middle. It's just a mistake in the comment.
> Ingo, do you want me to send an update with it ?

no need, i'll pick up the current patches.

	Ingo
