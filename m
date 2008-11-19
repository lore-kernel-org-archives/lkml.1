Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYKSXeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYKSXeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSXel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:34:41 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57850 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbYKSXek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:34:40 -0500
Message-ID: <4924A289.6030906@euromail.se>
Date: Thu, 20 Nov 2008 00:34:33 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: jg@laptop.org
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se>	 <20081119113508.ZZRA012@mailhub.coreip.homeip.net> <1227113699.7181.103.camel@jg-vaio>
In-Reply-To: <1227113699.7181.103.camel@jg-vaio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L2wZB-0000hu-6q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1L2wZB-0000hu-6q 80173a3a2688459e15ef8cd8e06b8c11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Gettys wrote:
[...]
> Also, I'm still concerned about using elipses. I doubt very much any
> hardware will ever be reporting elipses; more likely are parallelograms,
> or trapezoids, other simple geometric figures, rather than a center with
> size and orientation.

The bcm5974 chip is doing precisely this.

Henrik

