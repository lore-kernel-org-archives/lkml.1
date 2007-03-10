Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbXCJNvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbXCJNvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 08:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbXCJNvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 08:51:36 -0500
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:58568 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbXCJNvg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 08:51:36 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [PATCH][RSDL-mm 0/6]  Rotating Staircase DeadLine scheduler  for -mm
Date: Sun, 11 Mar 2007 01:03:20 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <1173527368.3380.1.camel@rousalka.dyndns.org>
In-Reply-To: <1173527368.3380.1.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703110103.21224.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 22:49, Nicolas Mailhot wrote:
> Oops
>
> ⇒ http://bugzilla.kernel.org/show_bug.cgi?id=8166

Thanks very much. I can't get your config to boot on qemu, but could you 
please try this debugging patch? It's not a patch you can really run the 
machine with but might find where the problem occurs. Specifically I'm 
looking for the warning MISSING STATIC BIT in your case. 

http://ck.kolivas.org/patches/crap/sched-rsdl-0.28-stuff.patch

Thanks!

-- 
-ck
