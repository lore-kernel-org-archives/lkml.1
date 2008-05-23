Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYEWKqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYEWKqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYEWKqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:46:18 -0400
Received: from s36.avahost.net ([74.53.95.194]:51115 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYEWKqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:46:17 -0400
Message-ID: <4836A06C.2050301@katalix.com>
Date: Fri, 23 May 2008 11:46:04 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Matthias Cramer <matthias.cramer@interway.ch>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Wired behaviour with IPv6 over PPP
References: <48341C0B.7010003@interway.ch> <20080522014959.0f6191aa.akpm@linux-foundation.org> <48354318.60202@katalix.com> <4835C40B.60603@interway.ch>
In-Reply-To: <4835C40B.60603@interway.ch>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Cramer wrote:
> James Chapman wrote:
>> Did this work with previous kernel versions?
> 
> No, in my opinion it never worked. But I thought that pppd does it wrong
> because id never got an IPv6 address. But I had always forwarding
> enabled. Now in this case i started pppd without forwarding enabled and
> got an address.
> 
>> Does pppd log any errors?
> 
> No, no errors

Could you post a pppd debug log showing the ppp protocol exchange with 
the peer in the failing case? It might give some clues.


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

