Return-Path: <linux-kernel-owner+w=401wt.eu-S1422926AbXBASfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422926AbXBASfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422925AbXBASfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:35:37 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:39467 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422926AbXBASfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:35:36 -0500
X-Greylist: delayed 2104 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 13:35:36 EST
Subject: Re: sky2 or acpi problem ?
From: Lionel Landwerlin <landwer@free.fr>
To: Fagyal Csongor <concept@conceptonline.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <45C22F57.3030804@conceptonline.hu>
References: <1170352795.5299.17.camel@cocoduo>
	 <45C22F57.3030804@conceptonline.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Feb 2007 19:35:32 +0100
Message-Id: <1170354932.6698.4.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 février 2007 à 19:20 +0100, Fagyal Csongor a écrit :
> Lionel Landwerlin wrote:

> I have idle=poll now, according to this thread:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/725399
> 
> 
> No lockup so far, but I only have this setting since yesterday...
> 

I tried idle=poll too, same effect than disable_msi=1, tested a couple
of hours only, maybe this leads to crash too. But anyway this is simply
unusable on a laptop (macbook), fan is running almost at full speed...


-- 
Lionel Landwerlin <landwer@free.fr>

