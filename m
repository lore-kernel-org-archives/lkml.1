Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZCQUTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZCQUTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZCQUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:18:49 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:45581 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZCQUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:18:48 -0400
Message-ID: <49C0059E.5050405@krogh.cc>
Date: Tue, 17 Mar 2009 21:18:38 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fubar@us.ibm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@redhat.com, aowi@novozymes.com
Subject: Re: Regression in bonding between 2.6.26.8 and 2.6.27.6 - bisected
 - twice
References: <20090313.161217.52045656.davem@davemloft.net>	<8799.1236986836@death.nxdomain.ibm.com>	<49BEB7DE.9000201@krogh.cc> <20090316.133559.173588446.davem@davemloft.net>
In-Reply-To: <20090316.133559.173588446.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jesper Krogh <jesper@krogh.cc>
> Date: Mon, 16 Mar 2009 21:34:38 +0100
> 
>> Jay Vosburgh wrote:
>>> 	The above fragment isn't needed for mainline, only for -stable.
>>>
>> Did you sent it off to the stable kernel maintainers?
> 
> The fix has to go into Linus's tree first.
> 
> I haven't integrated Jay's changes yet.

Excellent. I was just trying to make sure that it wasn't lost somewhere 
in the process.

-- 
Jesper
