Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYIZXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYIZXNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYIZXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:13:28 -0400
Received: from ebb.errno.com ([69.12.149.25]:1962 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYIZXN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:13:27 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 19:13:27 EDT
Message-ID: <48DD6A65.1060209@errno.com>
Date: Fri, 26 Sep 2008 16:04:05 -0700
From: Sam Leffler <sam@errno.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
References: <20080926215701.GC5972@tesla> <48DD687E.5060703@gmail.com> <20080926230149.GE5972@tesla>
In-Reply-To: <20080926230149.GE5972@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-Rhyolite-Metrics: ebb.errno.com; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Fri, Sep 26, 2008 at 03:55:58PM -0700, Maxim Levitsky wrote:
>   
>> If I understand this correctly, madwifi is no longer a non-free driver?
>>     
>
> MadWifi is based on a proprietary HAL which is slightly different
> than this one, so no, its still non-free. The "free" drivers where
> I think focus should be put in is ath5k and ath9k as they are now both
> merged as part of the Linux kernel.
>   

The hal is not proprietary; Atheros just won't allow me to release it.  
And there are significant differences between the two code bases.

    Sam


