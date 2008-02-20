Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYBTBhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYBTBhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYBTBh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:37:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60235 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYBTBh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:37:26 -0500
Message-ID: <47BB83E2.1030504@cn.fujitsu.com>
Date: Wed, 20 Feb 2008 09:35:30 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com>	<20080218134720.GA28851@elte.hu>	<47BA299A.3040207@cn.fujitsu.com>	<20080219185009.122ED2701BA@magilla.localdomain>	<47BB7922.1010400@cn.fujitsu.com> <20080220011822.C510B2701BA@magilla.localdomain>
In-Reply-To: <20080220011822.C510B2701BA@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote::
>>> Please elaborate on the rationale that justifies this change.
>>> I don't see it at all.
>> I have corrected the comment in the latest patch which has been apllied by Ingo.
>> Please refer to http://lkml.org/lkml/2008/2/18/575 and http://lkml.org/lkml/2008/2/19/119 .
> 
> You have yet to say anything to justify your change.

You mean the comment?

I mean I made a mistake about the comment so I changed it, and then
Valdis.Kletnieks pointed it out for me. And late I sent a revised
patch with your original comment untouched.

Sorry for my poor English.  :( 

Thanks
Shi Weihua

