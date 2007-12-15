Return-Path: <linux-kernel-owner+w=401wt.eu-S1763060AbXLOX3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763060AbXLOX3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXLOX33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:29:29 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51239 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbXLOX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:29:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sun, 16 Dec 2007 00:27:19 +0100
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Walker <dwalker@mvista.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org
References: <20071213003028.676998182@mvista.com> <200712151157.44278.mb@bu3sch.de> <200712160018.45613.rjw@sisk.pl>
In-Reply-To: <200712160018.45613.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712160027.19950.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
> Well, the only problem with that is I suspect there are some "newer" cards that
> work better with v3 firmware, although they are supposed to support both.

And I suspect that you are wrong until you show me one. :)

-- 
Greetings Michael.
