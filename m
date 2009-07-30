Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZG3R6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZG3R6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZG3R6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:58:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbZG3R6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:58:53 -0400
Date: Thu, 30 Jul 2009 10:59:00 -0700 (PDT)
Message-Id: <20090730.105900.232424702.davem@davemloft.net>
To: paul.moore@hp.com
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] net/netlabel: Add kmalloc NULL tests
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907301053.37416.paul.moore@hp.com>
References: <200907301032.20318.paul.moore@hp.com>
	<Pine.LNX.4.64.0907301637570.8734@ask.diku.dk>
	<200907301053.37416.paul.moore@hp.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>
Date: Thu, 30 Jul 2009 10:53:37 -0400

> On Thursday 30 July 2009 10:38:19 am Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> The test on map4 should be a test on map6.
>>
>> The semantic match that finds this problem is as follows:
>> (http://www.emn.fr/x-info/coccinelle/)
 ...
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Much better, thank you.
> 
> Acked-by: Paul Moore <paul.moore@hp.com>

Applied, thanks.

