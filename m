Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYIZXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYIZXVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYIZXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:21:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYIZXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:21:38 -0400
Message-ID: <48DD6E71.1060605@zytor.com>
Date: Fri, 26 Sep 2008 16:21:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Leffler <sam@errno.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
References: <20080926215701.GC5972@tesla> <48DD687E.5060703@gmail.com> <20080926230149.GE5972@tesla> <48DD6A65.1060209@errno.com>
In-Reply-To: <48DD6A65.1060209@errno.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Leffler wrote:
>>
>> MadWifi is based on a proprietary HAL which is slightly different
>> than this one, so no, its still non-free. The "free" drivers where
>> I think focus should be put in is ath5k and ath9k as they are now both
>> merged as part of the Linux kernel.
>>   
> 
> The hal is not proprietary; Atheros just won't allow me to release it.  
> And there are significant differences between the two code bases.
> 

Perhaps you and Luis can work together on fixing that problem?

And Luis, congratulations on your work so far.  It has really paid off.

	-hpa

