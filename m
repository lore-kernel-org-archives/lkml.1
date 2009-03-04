Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZCDOlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZCDOlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZCDOk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:40:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:49551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751818AbZCDOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:40:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6sWwignT6NTYm7ZQQX+piHxX++BKhlSsbMGQLu3
	kkQSY8+XXOcdFR
Subject: Re: x86-tip: cpufreq breakage
	-	bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236177327.6001.2.camel@marge.simson.net>
References: <1236085632.5958.8.camel@marge.simson.net>
	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
	 <49ADE077.1060606@kernel.org> <1236138205.6119.12.camel@marge.simson.net>
	 <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org>
	 <49AE4C26.4040104@kernel.org>  <49AE4D40.3050705@kernel.org>
	 <1236163460.6101.7.camel@marge.simson.net>  <49AE88F9.8060100@kernel.org>
	 <1236177327.6001.2.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 15:40:54 +0100
Message-Id: <1236177654.6001.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 15:35 +0100, Mike Galbraith wrote:
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
           ^7

