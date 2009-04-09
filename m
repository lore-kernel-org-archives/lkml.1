Return-Path: <linux-kernel-owner+w=401wt.eu-S935751AbZDITDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbZDITDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762311AbZDITDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:03:36 -0400
Received: from waste.org ([66.93.16.53]:49688 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761630AbZDITDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:03:35 -0400
Subject: Re: IRQF_SAMPLE_RANDOM question...
From: Matt Mackall <mpm@selenic.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Peterson <cpeterso@cpeterso.com>
In-Reply-To: <200904090954.54601.rgetz@blackfin.uclinux.org>
References: <200904061430.26276.rgetz@blackfin.uclinux.org>
	 <200904071744.17727.rgetz@blackfin.uclinux.org>
	 <1239220294.31467.55.camel@calx>
	 <200904090954.54601.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 10:00:59 -0700
Message-Id: <1239296459.31467.142.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 09:54 -0400, Robin Getz wrote:
> On Wed 8 Apr 2009 15:51, Matt Mackall pondered:
> > On Tue, 2009-04-07 at 17:44 -0400, Robin Getz wrote:
> > > Is that "Everything in general, with a few exceptions", or
> > > "__Everything__"?
> > 
> > Everything. We want every input point to better document the type of
> > entropy source.
> 
> OK - any objections to something like this?

Hmm, this is a purely internal interface. Not sure if we need to bother
with scheduling it. My plan was to simply get the new code in and sweep
the kernel. 

-- 
http://selenic.com : development and support for Mercurial and Linux


