Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbZLKAHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbZLKAHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZLKAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:07:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58834 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZLKAHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fopl/PS+C3Qr8wfd+FRfiiDyeva2lcWfgfmVF2pEaBUJ9YHpev4V2IlHC41vEvi0WW
         OdynBYUQonMg2Vz28uPDSWcf0p1jh7+a7OI/Ota73yCHGbG/SIBIcl0yuTHmlu9W+vFs
         k+T/afp7GCIVfOWfGdCPbIMT2vFL3Fb2mZGFM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0912101126480.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091210163326.28bb7eb8.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0912101126480.5481@router.home>
Date: Fri, 11 Dec 2009 09:07:53 +0900
Message-ID: <28c262360912101607s1d55a14q74ffe161dbad5de5@mail.gmail.com>
Subject: Re: [RFC mm][PATCH 1/5] mm counter cleanup
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 2:30 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:
>
>> This patch modifies it to
>>   - Define them in mm.h as inline functions
>>   - Use array instead of macro's name creation. For making easier to add
>>     new coutners.
>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Except Christoph pointed out, it looks good to me.


-- 
Kind regards,
Minchan Kim
