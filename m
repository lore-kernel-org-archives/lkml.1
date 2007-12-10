Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbXLJIfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbXLJIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXLJIfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:35:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLJIfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:35:00 -0500
Date: Mon, 10 Dec 2007 09:34:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] x64/page.h: convert some macros to inlines
Message-ID: <20071210083418.GB22699@elte.hu>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.469118000@nick.local0.net> <20071207163142.4e77f9c3.akpm@linux-foundation.org> <20071209210653.6d9f9cf9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209210653.6d9f9cf9.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > Could someone *please* start a little project of extirpating this 
> > utter brain damage?  Convert those macros to typechecked static 
> > inlines on x86 (at least) so this sort of thing (which happens again 
> > and again and again) is lessened?
> 
> Here's a start on it.  x86 only and only 4 functions so far. Builds 
> cleanly for i386 and x86_64.

great - applied.

	Ingo
