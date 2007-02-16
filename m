Return-Path: <linux-kernel-owner+w=401wt.eu-S1422890AbXBPA6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422890AbXBPA6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422983AbXBPA6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:58:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:54484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422890AbXBPA6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:58:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aggCsutio9Y+12dYncr3WX+teQgY3IUNTyolOve5ZZuBIoZBih3x8n/N/dDGy0k0j/tiX2ItmCJF6vW0yBbGikOrNK8QA6KVke98akY4KPnaIUhYlD91iStHt2A5bhDbcmRBH+wHpU/o0MBE9d6BM25cXC8QH4Lf7DBwVx7wmX0=
Message-ID: <7b69d1470702151658w603aab4ave1d17cc0b2c40a2b@mail.gmail.com>
Date: Thu, 15 Feb 2007 18:58:30 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "v j" <vj.linux@gmail.com>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <20070215165339.GB5285@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Theodore Tso <tytso@mit.edu> wrote:
>
> But so what?  How will that hurt *Linux*?  If the Embedded developers
> don't contribute changes back, it doesn't hurt us any if they go away
> and start paying $$$ to VxWorks instead of using Linux for free.
---

Well, this is somewhat oversimplified. If the device supports add-on
software, that may be good for the FLOSS community even if the
underlying OS is partly closed. And if they're returning changes and
patches from any work they do in the code kernel (aside from their
drivers), that is also good for the community. And there is some value
to the community in their hiring and/or growing developers who may
later contribute directly to the kernel. And there is even some value
in just the publicity and hype for Linux, which helps bring new people
in. I'm not saying those things are worth "enough", just that they're
worth
something.

---
> Contrawise, if Embedded developers do contribute their device driver
> changes back to the kernel, they will be fine.  ...
---

In fairness, though, some of the developers WILL bitch about your not
using a recent kernel and not providing patches until products ship,
despite that meeting the letter of the license. Some of the notes in
this thread do exactly that. And I HAVE seen real developers say
something very close to "Your code is based on a kernel too old to
have any value to us" even though they would also claim abuse if the
code hadn't been made available at all. And I've seen lots of cases
where laptop-centric developers rejected or simply ignored code
submitted by embedded developers.

I'm completely in line with participating fully in the community, but
it's important that the mainstream developers recognize that the
community is bigger than the laptop/server-room crowd.

scott
