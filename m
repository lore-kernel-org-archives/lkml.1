Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXBPBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXBPBsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423008AbXBPBsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:48:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423001AbXBPBsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:48:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k9ZE2cZcHK3G3FxJnD04DnpsldzOIpwL6K9nehm7sXV//Mf0k0guUlCkIcOnPcwVp7pGyy9k1ZtE2aLuhXObd5V5GvyBGmjTdqpi9kvQ+Is4uUb5dzmHjs44M+Arcfyknzr9Cgzz1C+wvc9tytv2wNEKDWwQHTNCFBWav7QD01Y=
Message-ID: <7b69d1470702151748l72a2de5ci5f8135f0f9b293b5@mail.gmail.com>
Date: Thu, 15 Feb 2007 19:48:37 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: GPL vs non-GPL device drivers
Cc: linux-kernel@vger.kernel.org, "v j" <vj.linux@gmail.com>,
       "Theodore Tso" <tytso@mit.edu>, "Dave Jones" <davej@redhat.com>
In-Reply-To: <200702151742.15850.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <200702151742.15850.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Gene Heskett <gene.heskett@verizon.net> wrote:

> This definition seems to be a bit like nailing jelly to a tree in that so
> far only one companies legal dept has pursued this to the point of
> actually getting a court verdict rendered.  That was the German ruling a
> link was given to earlier in this thread(s).
---

The German decision did not go anywhere near the question of kernel
modules. It was a nice victory that the court decided the license was
enforceable, but the details of the license are still largely
untested.

---
> ...

> I'm a bit like Clint Eastwood here, do you feel lucky?  If not, then
> please comply with the terms of the software you have chosen to base your
> product on.
---

Note that it's not just "lucy", but "rich". Both sides would spend a
LOT of money if this went to court in the US. And, of course, "the
terms of the software [license]" are exactly what the case would be
deciding. There wouldn't be a case unless the two parties had
different views of the terms of the license.

---
> As you have been told here repeatedly, a distribution to
> your customers of code that is based on the GPL'd kernel headers does
> bring you into non-compliance with the terms of the GPL.  You can do
> anything you want in house, but the minute that code ships, that is
> a "distribution" and the GPL applies in full force in that its all made
> GPL, or you cannot legally ship it.  I don't know how it can be said any
> plainer than that.  But of course IANAL, so talk to yours, please.
---

I also ANAL, but even so I can point out that your assertion and Greg
KH's assertions do not have the force of law.  Questions like "what is
a derived work" and "what does 'unrelated' mean" in the license are
just not black-and-white.

I don't like niggling about interpretation, either, especially with
material that someone has contributed to the community; I think it's
rude and possibly unethical and that not testing the limits avoids any
danger of impropriety. But claiming it's clear what the license
requires is simply misleading.

scott
