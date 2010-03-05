Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0CEHiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:38:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35855 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0CEHiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:38:54 -0500
Date: Fri, 5 Mar 2010 09:38:50 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100305073850.GA20980@matterhorn.verdurent.com>
Mail-Followup-To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
	Dima Zavin <dmitriyz@google.com>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
 <20100303190753.GB11471@core.coreip.homeip.net>
 <4B8EB99F.4080104@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8EB99F.4080104@jic23.retrosnub.co.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Mar 03, Jonathan Cameron wrote:
> > 
> > I was hoping IIO would fill the niche of framework for generic data
> > acquisition devices, regardless of how fast or slow they are.
> We are working on it, but unfortunately the 'fast' end of the scale is
> making it rather complex beast and there is still a fair bit of work
> to be done before we suggest merging into the main tree.  We allow
> for 'simple' drivers that do have very similar functionality to ALS as
> proposed. (i.e. they just handle some sysfs interfaces and device
> registration).
> 
> I certainly have no objection to taking light sensors back into IIO.
> (one never moved out!)  Obviously I'll want opinions from the individual

I suspect you are pointing to the tsl2563 driver here. It's rework (iio->als)
has been languishing in my tasklist for a couple of months now. I haven't had
time for testing.

I guess I'll wait some more to see where this discussion goes.

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
