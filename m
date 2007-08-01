Return-Path: <linux-kernel-owner+w=401wt.eu-S935112AbXHAPVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112AbXHAPVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935072AbXHAPVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:21:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935065AbXHAPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:21:00 -0400
Date: Wed, 1 Aug 2007 17:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>, teresa@kvitka.net,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
Message-ID: <20070801152045.GA26671@elte.hu>
References: <p73abtbpk2s.fsf@bingen.suse.de> <46B06815.10200@gmail.com> <46470.81.207.0.53.1185971693.squirrel@secure.samage.net> <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net> <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com> <46850.81.207.0.53.1185980760.squirrel@secure.samage.net> <20070801150939.GA24710@elte.hu> <46B0A30A.8020606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B0A30A.8020606@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> On 08/01/2007 05:09 PM, Ingo Molnar wrote:
> 
> >* Indan Zupancic <indan@nul.nu> wrote:
> >
> >>We could have independent problems with more or less the same 
> >>symptoms, at least Teresa's problem seems much worse than ours, and if 
> >>you and Ingo only experience a stuck delete key, it might be something 
> >>else.
> >
> >i experienced nothing in this area so far - if i experienced anything of 
> >the likes it would be long fixed! =B-)
> 
> Show-off...

ok, gotta qualify that with: '... and if it were easily reproducible and 
if the bug was in my code'. Much less of a show-off i guess? :)

	Ingo
