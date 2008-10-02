Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYJBF1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYJBF1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYJBF1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:27:49 -0400
Received: from 1wt.eu ([62.212.114.60]:4574 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYJBF1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:27:48 -0400
Date: Thu, 2 Oct 2008 07:27:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Message-ID: <20081002052746.GI24654@1wt.eu>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <20080930094346.307ef1e5@werewolf.home> <20080930075553.GB20241@elte.hu> <20080930100252.22bb4df5@werewolf.home> <20080930080546.GD20241@elte.hu> <20081001213328.GB7115@tilt.dandreoli.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081001213328.GB7115@tilt.dandreoli.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:33:28PM +0200, Domenico Andreoli wrote:
> On Tue, Sep 30, 2008 at 10:05:46AM +0200, Ingo Molnar wrote:
> > 
> > * J.A. Magallón <jamagallon@ono.com> wrote:
> > 
> > > > heh. Could you send a patch with a changelog please?
> > > 
> > > Here it goes...I hope its right.
> > 
> > applied to tip/x86/urgent, thanks!
> 
> Ingo, why did you require a patch? Was not it really more simple and
> easy for everyone to write it yourself? Since I am sure it was not only
> a laziness matter (really?), I am very curious to know the reason.

I see two things :
  - preserve authorship of the code
  - "laziness" as you call it, is the only way to scale for a maintainer.

Willy

