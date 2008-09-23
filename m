Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYIWHnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYIWHnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYIWHnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:43:13 -0400
Received: from mail.bigtelecom.ru ([87.255.0.61]:49169 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYIWHnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:43:12 -0400
Message-ID: <48D89E0C.9040407@bigtelecom.ru>
Date: Tue, 23 Sep 2008 11:43:08 +0400
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080818)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Machine Check Exception Re: NetDev! Please help!
References: <48D4F85C.8090709@bigtelecom.ru> <200809202111.01256.denys@visp.net.lb> <48D67239.9040006@gmail.com> <48D7385D.40107@bigtelecom.ru> <20080922065339.GA4399@ff.dom.local> <48D76813.9000603@bigtelecom.ru> <20080922112452.GB5314@ff.dom.local> <48D79709.80400@bigtelecom.ru> <20080922172349.GA2545@ami.dom.local>
In-Reply-To: <20080922172349.GA2545@ami.dom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I stop eth1 and eth0 and run "emegre portage" and get exception. Now i
think its not problem in network part.

I miss situation in 2.6.27 about multiqueue and traffic shaper because i
was have many work and was can't read all netdev list =(
As i understand 2.6.27-rc have support multiqueue, but how it will work
with HTB/SFQ?
Is tc rules must have in 2.6.27 one root queue (and all queue go to this
tree) or need to do many qdiscs and settings it to device queues (i was
read some about queue2band)?
If it is simple for you - can  you sort describe this part of changes?

P.S. I think now that problem not in network part of kernel and i think
i stop CC netdev and Denys Fedoryshchenko. Thanks for you doing and
thanks for help!

Thanks.

> Actually, it's quite well tested, especially by Denys, and I doubt it
> will be much better in 2.6.27. BTW, maybe start eth1, stop eth0 yet?
>
> Thanks,
> Jarek P.
>
>   
