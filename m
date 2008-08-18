Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYHRVn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYHRVn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHRVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:43:41 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53689 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbYHRVnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:43:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=l49ROO24BzUJRa2mSCXiW1SxR/0HxhgDcM9FmCSMbCrj5u4CUKZ3MZSRMVaT/nb4IJPg1Ub68TMHuj7AEzJ24j4dqAULAkgPk8OFFVG2X0IbXqaBjp95SEjZs5MI/erK;
Message-ID: <48A9ECE6.3050208@simon.arlott.org.uk>
Date: Mon, 18 Aug 2008 22:43:02 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, jgarzik@redhat.com,
       netdev@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, ranma+kernel@tdiedrich.de
Subject: Re: [linux-pm] forcedeth 10de:0373 doesn't work on resume
References: <4898AA28.8000507@simon.arlott.org.uk>	 <20080818134814.136105c9.akpm@linux-foundation.org>	 <200808182313.10235.rjw@sisk.pl>	 <48A9E8B3.4040800@simon.arlott.org.uk> <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com>
In-Reply-To: <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/08/08 22:34, Yinghai Lu wrote:
> On Mon, Aug 18, 2008 at 2:25 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>> On 18/08/08 22:13, Rafael J. Wysocki wrote:
>>
>>>> Is it still broken in current kernels?
>>>
>>> It probably is.
>>
>> If I have MSI enabled, it still doesn't work.
> 
> same problem with nv_shutdown about setting it to D3Hot?

I'm not sure what you're asking here...?

-- 
Simon Arlott
