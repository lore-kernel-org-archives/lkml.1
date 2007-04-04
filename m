Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXDDGiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXDDGiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXDDGiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:38:19 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36092 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753736AbXDDGiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:38:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=jSV9AxlyuTq+kCeZ3eEJrLwYg7lD7dp5Y5un9rbYkkuc5nze/zNftf8yMl2Jf4vpr52Ynohd2y9RkUapOIUNUXdM1rd6TdNWgIZ3CRFMo5HEZsef8eLGCRiuN/yKuwapQ+/0cLAatieeCBbNfzobLWUZcSH2dLugnDoYU+J9vck=  ;
X-YMail-OSG: hvYIF8IVM1m6ICyqciP3d6kTVrUW9lagwkbPf4GTViKzMYURz6ZxTKbxsAx6JCDRksR_l.6jhN0RLECrUK0cBF3gncOILsDZenO.RwEWM2m3XcDgMzPVzoogi9ljGMW9amYndV935xYyark-
Message-ID: <461347D1.6000508@yahoo.com.au>
Date: Wed, 04 Apr 2007 16:38:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patches] threaded vma patches (was Re: missing madvise functionality)
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<4612DCC6.7000504@cosmosbay.com>	<46130BC8.9050905@yahoo.com.au>	<46133A8B.50203@cosmosbay.com>	<46134124.2040705@yahoo.com.au> <20070403232624.11935e80.akpm@linux-foundation.org>
In-Reply-To: <20070403232624.11935e80.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry to change the subjet, I was initially going to send the
threaded vma cache patches on list, but then decided they didn't
have enough changelog!)

Andrew Morton wrote:
> On Wed, 04 Apr 2007 16:09:40 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Andrew, do you have any objections to putting Eric's fairly
>>important patch at least into -mm?
> 
> 
> you know what to do ;)
> 

Well I did review them when he last posted, but simply didn't have
much to say (that happened in a much older discussion about the
private futex problem, and I ended up agreeing with this approach).
Anyway I'll have another look when they get posted again.

-- 
SUSE Labs, Novell Inc.
