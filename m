Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0AGSSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0AGSSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272Ab0AGSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:18:09 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56097 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0AGSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HBINKsbRgdHS6fgNsZoE2jG7JZM9SZ2DhEhmfTcMQj76JLLuSqX02nOKavgPN2hdzf
         lPj4KcYBSb9pEZq1PUY6iV0CCc1iCgXiGxwXsh14WU9eHLf8DSyA+ePgcNkYD17FDRs6
         +zgUUKHALvVJDcVWJZRqcfbEK2JclGSpjyAbw=
Date: Thu, 7 Jan 2010 19:17:59 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107181759.GC3088@del.dom.local>
References: <4B455C62.6030504@majjas.com>
 <20100106205343.5460d658@nehalam>
 <4B4571D5.30002@majjas.com>
 <4B457711.1040008@majjas.com>
 <4B458B36.6050509@majjas.com>
 <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com>
 <20100107082140.GB7229@ff.dom.local>
 <4B45F7D7.3060308@majjas.com>
 <20100107175610.GA3088@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107175610.GA3088@del.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 06:56:10PM +0100, Jarek Poplawski wrote:
> [...] (try to grep in net\). [...]

Did I say "net\"?!

Extremely sorry! ;-)
Jarek P.
