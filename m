Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYDQIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYDQIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYDQIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:45:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbYDQIpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:45:38 -0400
Date: Thu, 17 Apr 2008 01:45:34 -0700 (PDT)
Message-Id: <20080417.014534.258800340.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080417014054.ea788f1f.akpm@linux-foundation.org>
References: <20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 17 Apr 2008 01:40:54 -0700

> By keeping all this code out of -mm you haven't solved any of the
> merge/integration problems which we had in 2.6.24-rcX.

I think things would have been a lot easier if you had adopted
basing -mm on top of linux-next from the very start.

The responsiveness to problems and merge hassles has been so much
superior and efficient from the linux-next folks for my networking
stuff, for example.  It's never been like that with -mm.
