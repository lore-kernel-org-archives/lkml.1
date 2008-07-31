Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYGaUfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYGaUfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYGaUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:35:04 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53322 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYGaUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:35:02 -0400
X-BigFish: VPS-38(zz1418M1432R98dR1805M936fQzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <48922293.9020007@am.sony.com>
Date: Thu, 31 Jul 2008 13:37:39 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf> <20080731153757.GB20212@cs181140183.pp.htv.fi> <20080731182616.4c20f0db@surf> <20080731164918.GE20212@cs181140183.pp.htv.fi> <4891F724.3030406@am.sony.com> <20080731191650.GA23516@cs181140183.pp.htv.fi>
In-Reply-To: <20080731191650.GA23516@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 20:34:46.0403 (UTC) FILETIME=[DEF9B530:01C8F34C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jul 31, 2008 at 10:32:20AM -0700, Tim Bird wrote:
>> If warnings or support avoidance for the general population using
>> such config options is the issue, I think that David Woodhouse's
>> suggestion that such things could taint the kernel is an interesting
>> idea. Maybe have we could have an "unsafe-config" taint flag?
> 
> A CONFIG_EMBEDDED=y flag?

If this is sufficient, it works for me!

> It's not only about limits, I also have a general dislike for the
> "add more config options" approach.
> 
> I get your point why it brings advantages in some cases, but if you are 
> looking for a cheerleader it won't be me.  ;-)

Understood.  I promise not to send you any pom-poms. ;-)
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

