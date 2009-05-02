Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZEBUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZEBUuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbZEBUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:49:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55477
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbZEBUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:49:51 -0400
Date: Sat, 02 May 2009 13:49:45 -0700 (PDT)
Message-Id: <20090502.134945.07397681.davem@davemloft.net>
To: mmvinni@yahoo.com
Cc: rabin@rab.in, shemminger@vyatta.com, netdev@vger.kernel.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: br2684: convert to net_device_ops broke it
From: David Miller <davem@davemloft.net>
In-Reply-To: <907051.51698.qm@web58405.mail.re3.yahoo.com>
References: <777914.38491.qm@web58405.mail.re3.yahoo.com>
	<20090502134605.GA11168@debian>
	<907051.51698.qm@web58405.mail.re3.yahoo.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Vinni <mmvinni@yahoo.com>
Date: Sat, 2 May 2009 13:02:40 -0700 (PDT)

> 
> Rabin Vincent wrote:
> 
>> On Sat, May 02, 2009 at 02:04:21AM -0700, Mikko Vinni wrote:
>> > my ADSL connection works well with kernel 2.6.29, but since commit
>> > 0ba25ff4c669e5395110ba6ab4958a97a9f96922 (br2684: convert to net_device_ops)
>> > entered the mainline using br2684ctl fails with the following bug:
>> [..]
>> > I'll be glad to test any patches.
>> 
>> Please try the one below.
> 
> Yes, that fixes it. Good job and thank you!

Patch applied, thanks everyone.
