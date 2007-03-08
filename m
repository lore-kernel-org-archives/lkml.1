Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214AbXCHC5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbXCHC5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXCHC5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:57:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXCHC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:57:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HApL7MRchIiMWvwUxqjdzu02g1ahe0gK/LqIIr/C5LIWb6oVRSiC26tw1iPklZ2AD
	hXj+kQDRcK3hoxB+yAPNw==
Message-ID: <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
Date: Wed, 7 Mar 2007 18:57:01 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
In-Reply-To: <45EF793C.1000700@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	 <45EF5E71.7090101@vilain.net>
	 <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	 <45EF793C.1000700@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
>
> Sorry, I didn't realise I was talking with somebody qualified enough to
> speak on behalf of the Generally Established Principles of Computer Science.

I made sure to check

http://en.wikipedia.org/wiki/Namespace
http://en.wikipedia.org/wiki/Namespace_%28computer_science%29

when this argument started ... :-)

>
> This is the classic terminology problem between substance and function.
> ie, some things share characteristics but does that mean they are the
> same thing?

Aren't you arguing my side here? My point is that what I'm trying to
add with "containers" (or whatever name we end up using) can't easily
be subsumed into the "namespace" concept, and you're arguing that they
should go into nsproxy because they share some characteristics.

>
> Look, I already agreed in the earlier thread that the term "namespace"
> was being stretched beyond belief, yet instead of trying to be useful
> about this you still insist on calling this sub-system specific stuff
> the "container",

Uh, no. I'm trying to call a *grouping* of processes a container.

> and then go screaming that I am wrong and you are right
> on terminology.

Actually I asked if you/Eric had better suggestions.

Paul
