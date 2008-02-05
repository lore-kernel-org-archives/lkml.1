Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYBELd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYBELd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYBELdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:33:18 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34217 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYBELdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:33:17 -0500
References: <20080125180232.GA4613@kroah.com>
            <20080202123710.42df1aa0@weinigel.se>
            <20080202191930.GA19826@kroah.com>
            <47A5D9CD.5070001@davidnewall.com>
            <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
            <47A5E67D.9040804@davidnewall.com>
            <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
In-Reply-To: <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
From: David Newall <davidn@davidnewall.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Greg KH" <greg@kroah.com>, "Christer Weinigel" <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Tue, 05 Feb 2008 22:03:15 +1030
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.47A8497B.0000472E@hawking.rebel.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg writes:
> I think you're missing my point: as long as the license stays the way
> it is now, you can never distribute proprietary code unless you've
> consulted a lawyer and even then you run the risk of being sued for
> infringement if the copyright holder thinks what you have is derived
> work.

Yes I can, if the proprietary code is not linked with GPL code (and the 
proprietary code is original).  Loadable modules are not linked.  This is a 
very clear-cut case.
