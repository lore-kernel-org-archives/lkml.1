Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYJOBL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYJOBL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJOBLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:11:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbYJOBLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:11:20 -0400
Date: Tue, 14 Oct 2008 23:10:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Douglas Landgraf <dougsland@gmail.com>,
       Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH 3/3] Don't let Avermedia Radio FM800 be detected as a
 normal HID device
Message-ID: <20081014231059.13833f96@pedra.chehab.org>
In-Reply-To: <alpine.LNX.1.10.0810142225480.26779@jikos.suse.cz>
References: <20081014111023.04c8a059@pedra.chehab.org>
	<alpine.LNX.1.10.0810142222330.26779@jikos.suse.cz>
	<alpine.LNX.1.10.0810142225480.26779@jikos.suse.cz>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Oct 2008 22:26:17 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 14 Oct 2008, Jiri Kosina wrote:
> 
> > > Based on an original patch from Alexey Klimov <klimov.linux@gmail.com>,
> > > against kernel version 2.6.27.
> > this is a rather short changelog ... what is the reason here? I guess 
> > there is a proper driver for this device somewhere in drivers/video, 
> > right?
> 
> OK, now I see, it's radio-mr800 driver. I will update the changelog 
> accordingly. Thanks.
> 
Yes.

Since the radio driver is already upstream, it would be interesting to have
this patch also for 2.6.28.

-- 

Cheers,
Mauro
