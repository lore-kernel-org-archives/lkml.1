Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYF0Ffb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYF0Ffb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYF0FfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:35:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38924 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYF0FfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:35:17 -0400
Message-ID: <48647C10.1090604@garzik.org>
Date: Fri, 27 Jun 2008 01:35:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jie Yang <Jie.Yang@Atheros.com>
CC: Jay Cliburn <jacliburn@bellsouth.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com> <20080626214510.01373505@osprey.hogchain.net> <72981EBCFD196144B7C6999B9FC34A9A3EE603BB7C@SHEXMB-01.global.atheros.com>
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A3EE603BB7C@SHEXMB-01.global.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jie Yang wrote:
> From: Jay Cliburn [acliburn@bellsouth.net]
> Date: Friday, June 27, 2008 10:45 AM
> 
>> Patches 1 and 2 reviewed tonight.  I intend to review the
>> other 3 in coming days.
> 
> Thanks for your help.
> I will update source code on these comments.
> 
>> On Thu, 26 Jun 2008 13:37:23 +0800
>> Jie Yang <Jie.Yang@Atheros.com> wrote:
>>
>>> From: Jie Yang <jie.yang@atheros.com>
>>>
>>> Full patch for the Atheros L1E Gigabit Ethernet driver.
>>> Supportring AR8121, AR8113 and AR8114
>> Please generate the patch against current mainline (or at
>> least current -rc); it fails to apply cleanly as is.
>>
> 
> how about use the git
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

You'll want to use

git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git

Regards,

	Jeff


