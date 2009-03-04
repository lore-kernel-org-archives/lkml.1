Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZCDRIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZCDRIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZCDRI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:08:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58589 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZCDRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:08:26 -0500
Date: Wed, 4 Mar 2009 18:08:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage - bisection fingers
	89c9215165ca609096e845926d9a18f1306176a4
Message-ID: <20090304170820.GA7095@elte.hu>
References: <1236098338.5926.0.camel@marge.simson.net> <49ADE077.1060606@kernel.org> <1236138205.6119.12.camel@marge.simson.net> <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org> <49AE4C26.4040104@kernel.org> <49AE4D40.3050705@kernel.org> <1236163460.6101.7.camel@marge.simson.net> <49AE88F9.8060100@kernel.org> <1236177327.6001.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236177327.6001.2.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2009-03-04 at 22:58 +0900, Tejun Heo wrote:
> > Mike Galbraith wrote:
> > > On Wed, 2009-03-04 at 18:43 +0900, Tejun Heo wrote:
> > >> Tejun Heo wrote:
> > >>> I've used the config file you attached and the commit ID I used is
> > >>> d0c4f570276cb4d2dc4215b90eb7cb6e2bdd4a15.
> > > 
> > > My tip tree is at v2.6.29-rc6-2441-g4239438.
> > 
> > Eh... how do I map that to git commit?
> 
> The last 6, short form of 4239438b08fe8ec149ddc530238ca131bf88d290.

yes - but recent enough Git will do this for you automatically 
as well.

	Ingo
