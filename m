Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZHSIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZHSIZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZHSIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:25:46 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:44471 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZHSIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <28c262360908190029j1153b00fva11c4a215d5932d6@mail.gmail.com>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	 <4A8B7508.4040001@vflare.org>
	 <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
	 <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
	 <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
	 <18eba5a10908190014q6f903399y30478b4c0a7f256b@mail.gmail.com>
	 <28c262360908190029j1153b00fva11c4a215d5932d6@mail.gmail.com>
Date: Wed, 19 Aug 2009 13:55:44 +0530
Message-ID: <d760cf2d0908190125y1aa033fcx2ff6ebfcbe54356f@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: Nitin Gupta <ngupta@vflare.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Chungki woo <chungki.woo@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 12:59 PM, Minchan Kim<minchan.kim@gmail.com> wrote:
> On Wed, Aug 19, 2009 at 4:14 PM, Chungki woo<chungki.woo@gmail.com> wrote:
>>> You means your pages with 79M are swap out in compcache's reserved
>>> memory?
>>
>> Compcache don't have reserved memory.
>> When it needs memory, and then allocate memory.
>
> Okay. reserved is not important. :)
> My point was that 79M with pages are swap out in compcache swap device ?
> Is the number real ?
> Can we believe it ?
>


I would suggest moving compcache related discussion over to
linux-mm-cc AT laptop DOT org
as this might not be of such general interest. I would be glad to
discuss your doubts in detail.

See you over there.

Thanks,
Nitin
