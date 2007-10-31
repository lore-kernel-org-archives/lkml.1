Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbXJaEuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbXJaEuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXJaEt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:49:59 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:25772 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752551AbXJaEt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:49:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RRJ3tLGh6AtvW7reJZAU8mSUe3FRNmm37FFkXBR7kYI+Rmk6Q8WaLSOLEKdgKeuxdbhgdGsE9tjYoYAYK5hQffuMkWTLl2luBmmdDtFxmb1dJUffKbW45zo7egnDvh/kB3dh1io3hidMIHH1rqqfC1suxbDLpaKRABBxJNovCTU=  ;
X-YMail-OSG: NkakwB0VM1k3OSSam3Y0crZQXTcT3CkF0rrqfoMqDrlw8CP4a0mDzHNNRGrSpZQY1mqCyJ6ZOA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/33] mm: kmem_estimate_pages()
Date: Wed, 31 Oct 2007 14:43:17 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <20071030160911.281698000@chello.nl>
In-Reply-To: <20071030160911.281698000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311443.18143.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Provide a method to get the upper bound on the pages needed to allocate
> a given number of objects from a given kmem_cache.
>

Fair enough, but just to make it a bit easier, can you provide a
little reason of why in this patch (or reference the patch number
where you use it, or put it together with the patch where you use
it, etc.).

Thanks,
