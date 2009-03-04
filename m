Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZCDKoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZCDKoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZCDKoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:44:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:50894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751168AbZCDKo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:44:29 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mENNdcTjmfEHUunEr9X+oGZx0+H36yTgcU2jmlr
	xbntXku0Wl3xEz
Subject: Re: x86-tip: cpufreq breakage -
	bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49AE4D40.3050705@kernel.org>
References: <1236085632.5958.8.camel@marge.simson.net>
	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
	 <49ADE077.1060606@kernel.org> <1236138205.6119.12.camel@marge.simson.net>
	 <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org>
	 <49AE4C26.4040104@kernel.org>  <49AE4D40.3050705@kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:44:20 +0100
Message-Id: <1236163460.6101.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 18:43 +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > I've used the config file you attached and the commit ID I used is
> > d0c4f570276cb4d2dc4215b90eb7cb6e2bdd4a15.

My tip tree is at v2.6.29-rc6-2441-g4239438.
 
> > I wonder what is going on.  I'll try again with
> > 89c9215165ca609096e845926d9a18f1306176a4.  Argh... weird.
> 
> One thing.  The config file you attached earlier doesn't have all the
> config vars for the above commits.  Is it the correct config file?

Yes, verified.

	-Mike



