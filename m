Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZDSEa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZDSEa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZDSEaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:30:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZDSEaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:30:20 -0400
Date: Sat, 18 Apr 2009 21:30:11 -0700 (PDT)
Message-Id: <20090418.213011.50580925.davem@davemloft.net>
To: holt@sgi.com
Cc: mcarlson@broadcom.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, benli@broadcom.com, mchan@broadcom.com,
       James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC
 addresses on BCM5701
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090417122121.GP10768@sgi.com>
References: <20090416.174310.260350758.davem@davemloft.net>
	<20090417005804.GA16432@xw6200.broadcom.net>
	<20090417122121.GP10768@sgi.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Fri, 17 Apr 2009 07:21:21 -0500

>> Actually, I think we do have a fix for this.  James and Robin both
>> reported that the test patch I sent out worked for them.  I'm preparing
>> a patchset for submission now.
>> 
>> James, Robin, can you confirm that you performed your tests with David's
>> patch reverted?
> 
> My test was done with the 2.6.28-rc1 kernel plus your patch and no
> others.

Can I get a final patch against Linus's current tree?

Thanks.
