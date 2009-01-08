Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZAHOys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZAHOys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZAHOyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:54:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZAHOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:54:38 -0500
Date: Thu, 8 Jan 2009 15:54:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, davej@redhat.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Message-ID: <20090108145410.GG18120@elte.hu>
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com> <20090107130742.GD2520@shadowen.org> <3f9a31f40901070527y31fcccc9n5b3d52faa58e359e@mail.gmail.com> <20090107235037.GF12402@shadowen.org> <3f9a31f40901072040x4e1e3be9vece333b19a24a645@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901072040x4e1e3be9vece333b19a24a645@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Thu, Jan 8, 2009 at 5:20 AM, Andy Whitcroft <apw@canonical.com> wrote:
> >
> > Thanks thats great.  I think I have this fixed in my tree now.  Can you
> > test with the version at the url below:
> >
> >  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> >
> 
> Thanks Andy, this works for me.

Could we please push this fix upstream ASAP?

	Ingo
