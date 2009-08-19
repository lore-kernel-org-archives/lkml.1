Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbZHSH3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbZHSH3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZHSH3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:29:35 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:40363 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZHSH3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kyle7whncrtEQ+shVJU7UhI5Per7L9ZFCf9zCp2ORPddpKPKGA/pzmZ2GvKOKy95x4
         iPgc905uo126sVaACWQ3hUDVA9AB7WlbGdARneLMnzDWuU4885sS4ontrsKK/aKwj85q
         uyMRXoyAnwchnV113cs4virzP9xDjcMFXMTUc=
MIME-Version: 1.0
In-Reply-To: <18eba5a10908190014q6f903399y30478b4c0a7f256b@mail.gmail.com>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	 <4A8B7508.4040001@vflare.org>
	 <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
	 <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
	 <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
	 <18eba5a10908190014q6f903399y30478b4c0a7f256b@mail.gmail.com>
Date: Wed, 19 Aug 2009 16:29:35 +0900
Message-ID: <28c262360908190029j1153b00fva11c4a215d5932d6@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: Minchan Kim <minchan.kim@gmail.com>
To: Chungki woo <chungki.woo@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, ngupta@vflare.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 4:14 PM, Chungki woo<chungki.woo@gmail.com> wrote:
>> You means your pages with 79M are swap out in compcache's reserved
>> memory?
>
> Compcache don't have reserved memory.
> When it needs memory, and then allocate memory.

Okay. reserved is not important. :)
My point was that 79M with pages are swap out in compcache swap device ?
Is the number real ?
Can we believe it ?

>
> Thanks.
>



-- 
Kind regards,
Minchan Kim
