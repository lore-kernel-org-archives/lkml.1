Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZJ0FVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZJ0FVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZJ0FVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:21:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58745
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbZJ0FVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:21:36 -0400
Date: Mon, 26 Oct 2009 22:22:00 -0700 (PDT)
Message-Id: <20091026.222200.53878862.davem@davemloft.net>
To: david@lang.hm
Cc: stefanr@s5r6.in-berlin.de, mingo@elte.hu, gregkh@suse.de,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: removing existing working drivers via staging
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm>
References: <4AD77C4F.5010307@s5r6.in-berlin.de>
	<alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm>
	<alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: david@lang.hm
Date: Mon, 26 Oct 2009 21:23:35 -0700 (PDT)

> where a driver is being moved to staging because it does not have a
> maintainer and the only changes to it for some time have been due to
> kernel API changes.

It's also in a non-working condition and we are very confident
nobody is using it.

It hasn't been maintained at all for years, it's just taking up
space.
