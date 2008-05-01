Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbYEAQbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbYEAQbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbYEAQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:31:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:19199 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbYEAQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sivn1ihud18PvjGZemNhqjm8Bm9fqgdkBQ4xhIm4Vb2lUbjSOKWJ8Alpzb8WmKcQcoqmBPBvArF/ZrdoPJ9DXUFifHVkYZgCIiInouz4LqoQL0hXBOAyqvfOyiwHaN5G3PPRYfQ6bp5Df61E+z40CIUx3LO37HX5WNzvkIGNKtE=
Message-ID: <4819F064.903@gmail.com>
Date: Thu, 01 May 2008 20:31:32 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	<20080430135405.ddc42075.akpm@linux-foundation.org>	<4818E7E3.7080705@gmail.com>	<20080430151007.0ace4fa2.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>	<4818F291.2050706@gmail.com> <20080501182658.9bbf5d4a.diegocg@gmail.com>
In-Reply-To: <20080501182658.9bbf5d4a.diegocg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja пишет:
> El Thu, 01 May 2008 02:28:33 +0400, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> escribió:
> 
>> Linus, thanks a lot for the detailed explanation. Indeed, it seems that I foolishly
>> tried to duplicate Stephen's work. In the future I'll do as you suggest here.
> 
> That "howto" should probably be added to the linux-next announcements...
> (CC'ing Stephen)
> 

Excellent idea. Thanks, Diego!

Dmitri
