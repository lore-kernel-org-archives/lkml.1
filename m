Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbXCKJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbXCKJVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXCKJVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 05:21:23 -0400
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:38297 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbXCKJVX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 05:21:23 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [BIG] Re: sched rsdl fix for 0.28
Date: Sun, 11 Mar 2007 20:21:15 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
References: <200703111107.00704.kernel@kolivas.org> <1173604223.3550.2.camel@rousalka.dyndns.org>
In-Reply-To: <1173604223.3550.2.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703112021.15172.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 20:10, Nicolas Mailhot wrote:
> Le dimanche 11 mars 2007 à 11:07 +1100, Con Kolivas a écrit :
> > sched rsdl fix
>
> Doesn't change a thing. Always breaks at the same place (though
> depending on hardware timings? the trace is not always the same). Pretty
> sure nothing happens before this failure

Bummer. The only other thing to try is v0.29 posted recently. I still haven't 
got a good way to reproduce this locally but I'll keep trying. Thanks for 
testing.

-- 
-ck
