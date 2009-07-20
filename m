Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZGTRxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZGTRxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZGTRxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:53:30 -0400
Received: from dns1.vpop.net ([216.193.240.2]:53078 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZGTRx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:53:29 -0400
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>
Message-Id: <1ABCC50C-CB75-44E4-8F7A-51D8E275EC0C@vpop.net>
From: Matt Reimer <mreimer@vpop.net>
To: Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Date: Mon, 20 Jul 2009 10:53:27 -0700
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 16, 2009, at 8:44 AM, Daniel Mack wrote:

> This adds a function to let the power supply core know that the  
> battery
> is fully charged now. This can be done by watching a GPIO line, for
> example.
>
> Some battery drivers might need that information to calibrate
> themselves.

Looks fine to me.

Acked-by: Matt Reimer <mreimer@vpop.net>

Matt
