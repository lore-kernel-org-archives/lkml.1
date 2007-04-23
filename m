Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXDWSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXDWSgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXDWSgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:36:19 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:11252 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161309AbXDWSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gdefvI4jLwDW5Ue48XMH6OOuADvtMuX/OeiTkW3XGVWivRRf1HeAabJhbnSLHp7en9wvc/bFm9rYHP1z1NT6eU6ZVrvaJBfS8UUrKa8ZenRW/mJF43DmHtlTAKbskOnCGjTBZHkV+XbkErkw+Up+OYqrjSEGAXv0Ek6AFxueZiE=
Message-ID: <653402b90704231136x6f28c2b6i28a3a28dd840ab14@mail.gmail.com>
Date: Mon, 23 Apr 2007 20:36:15 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Question about Reiser4
Cc: "Eric Hopper" <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070423104042.87b50bb3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070423020046.GA28477@omnifarious.org>
	 <462C4858.3050006@redhat.com>
	 <Pine.LNX.4.64.0704230555020.25153@server.thyself>
	 <462C4D32.4000909@redhat.com>
	 <Pine.LNX.4.64.0704230611430.25153@server.thyself>
	 <462C5034.9090403@redhat.com>
	 <Pine.LNX.4.64.0704230640540.25153@server.thyself>
	 <20070423010445.454eda63.akpm@linux-foundation.org>
	 <20070423135216.GA2744@omnifarious.org>
	 <20070423104042.87b50bb3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> To get it unstuck we'd need a general push, get people looking at and
> testing
> the code, get the vendors to have a serious think about it, etc.  We could
> do
> that - it'd require that the namesys people (and I) start making threatening
> noises about merging it, I guess.
>
> Or we could move all the reiser4 code into kernel/sched.c - that seems to
> get
> people fired up.
> -

Just an idea: And what about creating a new tree (like -r4),
maintained by namesys people, tested by several people, with dedicated
mailing list, etc.?

That way, the code could be patched, updated and cleaned over the time
(without firing up people), it could be tested without pain, people
would send more bug reports and every work would be centralized.
Reiser4 would get much more attention.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
