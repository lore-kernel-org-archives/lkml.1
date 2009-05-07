Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbZEGKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbZEGKEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZEGKEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:04:08 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:54829 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZEGKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:04:07 -0400
Message-ID: <4A02B1CA.3060708@hiramoto.org>
Date: Thu, 07 May 2009 12:02:50 +0200
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090323)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com>
In-Reply-To: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> For those not subscribed to the ath9k wiki on wireless.kernel.org [1]
> (which we recommend you do if you're a user) here's a quick note to
> let you know our latest kernel recommendations for using ath9k:
>
>   *  >= 2.6.27.22
>   *  >= 2.6.28.10
>   *  2.6.29
>
> If you want 802.11n support or AP support you'll want at least 2.6.29.
> If you happen to have one of our new 1x1 AR9285 devices (all AR9285
> devices are 1x1) then you'll need at least 2.6.29. If you want to
> start using ath9k on APs with AHB you will need at least 2.6.30 (still
> in RC series).
>
> As usual if you happen to be stuck on older kernels for one reason or
> another you can always use compat-wireless [2] and if that happens to
> be a little too bleeding edge we have now compat-wireless releases for
> stable kernel releases, starting as of the 2.6.30-rc series [3].
>
>   Luis
>
> [1] http://wireless.kernel.org/en/users/Drivers/ath9k
> [2] http://wireless.kernel.org/en/users/Download
> [3] http://wireless.kernel.org/en/users/Download/stable
>   
Thanks for the update.  If i want to use multiple AP's with Ath9k it it 
still best to use wireless-testing?  Is multiple AP support in 2.6.30-rc 
series net-next or wireless-next?

Thanks.
--
Karl
