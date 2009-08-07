Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZHGOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZHGOTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZHGOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:19:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:32413 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZHGOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:19:20 -0400
Message-ID: <4A7C37E5.4040302@codemonkey.ws>
Date: Fri, 07 Aug 2009 09:19:17 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com>
In-Reply-To: <20090806081955.GA9752@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>
>> This series includes the basic plumbing, as well as the driver for
>> accelerated 802.x (ethernet) networking.
>>     
>
> The graphs comparing virtio with vbus look interesting.
>   

1gbit throughput on a 10gbit link?  I have a hard time believing that.

I've seen much higher myself.  Can you describe your test setup in more 
detail?

Regards,

Anthony Liguori
