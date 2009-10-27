Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZJ0Fuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZJ0Fuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZJ0Fup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:50:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:43002 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZJ0Fup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:50:45 -0400
Date: Mon, 26 Oct 2009 22:50:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Miller <davem@davemloft.net>
cc: stefanr@s5r6.in-berlin.de, mingo@elte.hu, gregkh@suse.de,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: removing existing working drivers via staging
In-Reply-To: <20091026.222200.53878862.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0910262237580.14994@asgard.lang.hm>
References: <4AD77C4F.5010307@s5r6.in-berlin.de> <alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm> <alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm> <20091026.222200.53878862.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009, David Miller wrote:

> From: david@lang.hm
> Date: Mon, 26 Oct 2009 21:23:35 -0700 (PDT)
>
>> where a driver is being moved to staging because it does not have a
>> maintainer and the only changes to it for some time have been due to
>> kernel API changes.
>
> It's also in a non-working condition and we are very confident
> nobody is using it.
>
> It hasn't been maintained at all for years, it's just taking up
> space.

this is the first I have seen anyone say that the driver doesn't work, 
everything prior had been "I don't know that it works, do you?"

I agree that it's unlikly that many people are using this.

David Lang
