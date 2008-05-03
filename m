Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYECGU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYECGU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYECGUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:20:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:43149 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754053AbYECGUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:20:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4A2oWAPO4x1n12bKdu2XsKsD2e7LF0x98R957EA
	KqUQyyGYUDmsK6
Subject: Re: 'global' rq->clock (was Re: Horrendous Audio Stutter - current
	git)
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frans Pop <elendil@planet.nl>, Parag Warudkar <parag.warudkar@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1209758186.6929.18.camel@lappy>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
	 <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net> <1209758186.6929.18.camel@lappy>
Content-Type: text/plain
Date: Sat, 03 May 2008 08:20:43 +0200
Message-Id: <1209795643.4847.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 21:56 +0200, Peter Zijlstra wrote:
> On Fri, 2008-05-02 at 21:27 +0200, Mike Galbraith wrote:
> 
> That's a quite horrible patch for some of us, but I think I know why you
> did that, and I think your fancy Q6600 has a stable enough TSC to pull
> it off.

Oh, yeah, that's right.  Bah, let them eat cake ;-) 

	-Mike

