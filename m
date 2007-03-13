Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXCMEcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXCMEcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXCMEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:32:20 -0400
Received: from 1wt.eu ([62.212.114.60]:1149 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXCMEcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:32:20 -0400
Date: Tue, 13 Mar 2007 05:32:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Message-ID: <20070313043206.GN943@1wt.eu>
References: <200703121058.11966.kernel@kolivas.org> <20070312.164652.108743760.davem@davemloft.net> <200703131405.23482.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703131405.23482.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 02:05:23PM +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 10:46, David Miller wrote:
> > From: Con Kolivas <kernel@kolivas.org>
> > Date: Mon, 12 Mar 2007 10:58:11 +1100
> >
> > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> > >30.patch
> >
> > FWIW, this boots and seems to work well on sparc64.  Tested
> > on UP SunBlade1500 and 24cpu Niagara T1000.
> 
> Very nice. Thanks for the feedback and I'm sorry you have to work with such 
> lousy hardware.

BTW, I don't know if you say this as a joke, but those are not necessarily
lousy hardware. Sun does lousy hardware when they put Sparcs in PCs (ultra5,
ultra10, blade100). But their servers generally are nice with large memory
busses and very scalable SMP architectures.

Regards,
Willy

