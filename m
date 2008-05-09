Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYEIWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYEIWxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYEIWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:53:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbYEIWxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:53:30 -0400
Message-ID: <4824D568.1050900@redhat.com>
Date: Fri, 09 May 2008 18:51:20 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       jeff@garzik.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org>	<4824606E.3040409@garzik.org>	<alpine.LFD.1.10.0805090805210.3142@woody.linux-foundation.org>	<20080509.144359.194792251.davem@davemloft.net> <20080509165832.12488cb8@osprey.hogchain.net>
In-Reply-To: <20080509165832.12488cb8@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> On Fri, 09 May 2008 14:43:59 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
>> BTW, this reminds me, did we get that driver in for the device the
>> EEPC machines use?  I have this strange feeling like that slipped
>> through the cracks.
> 
> That'd be the Atheros/Attansic L2 NIC.  I don't think it's quite ready
> yet.
> 
> [Adding Chris Snook to the cc list.]

I had a sudden shortage of Copious Free Time for the past few weeks. 
I'm going to post it this weekend.  Once it's merged with the atlx code, 
it'll be much easier for others to help out with it.

-- Chris
