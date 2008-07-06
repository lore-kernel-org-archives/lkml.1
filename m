Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYGFHH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYGFHH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 03:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYGFHHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 03:07:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27607 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYGFHHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 03:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hAFUGmjDKdP7KglLDVzZ8Sulg7x6gfwqfkS1qMoCauAQ7/skAY2EnnWKuf/z7FalO1
         5N+1lj5Aj5a5cIrc2+nA9yCtysQkr6xai3x9oPt/LYXoIBcM3ar0jaexVO72k5l4M7rb
         VsDo+f3+yGpzgpKYdKbY1Qfmytnx5eEhXReF4=
Message-ID: <1ba2fa240807060007i572d054va60aa16b41cadce3@mail.gmail.com>
Date: Sun, 6 Jul 2008 10:07:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2008-07-02
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080705.214752.85024966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080630215651.GA666@tuxdriver.com>
	 <20080702193710.GA4682@tuxdriver.com>
	 <20080702202653.GA10719@tuxdriver.com>
	 <20080705.214752.85024966.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 7:47 AM, David Miller <davem@davemloft.net> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 2 Jul 2008 16:26:53 -0400
>
>> Here is another slew of updates for 2.6.27.  The bulk of this batch is
>> for iwlwifi, with some mac80211 and other bits thrown-in.
>>
>> Let me know if there are problems!
>
> Pulled and pushed back out to net-next-2.6, thanks.
>
> Here are some warnings I noticed during an allmodconfig build
> on sparc64, please fix:
>
> drivers/net/wireless/hostap/hostap_hw.c:3422: warning: 'prism2_suspend' defined but not used
> drivers/net/wireless/iwlwifi/iwl-rfkill.c:114: warning: label 'freed_rfkill' defined but not used

John what happened to to those patches?
http://marc.info/?l=linux-wireless&m=121489830307988&w=2
http://marc.info/?l=linux-wireless&m=121481826531792&w=2
Thanks
Tomas
