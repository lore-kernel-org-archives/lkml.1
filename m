Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXBPBYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXBPBYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXBPBYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:24:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:14611 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXBPBYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EnASDkr67aqSjH81XeO7+iqZs7bcPztssBUbZuU+DzdjgDFx3IsUIl3PADf5hnWzLflvIg9EnPxaW1822iEgA2T4Q9PQ2Y43KVtIIdhFFnQFB+bPgQPL9wfFWi1dM58VXPnTiebe45d0K/WVVTbJZkCerlYvxA0Yj9yKNRRmL3A=
Message-ID: <7b69d1470702151724q141f074ak8b654f2abd581823@mail.gmail.com>
Date: Thu, 15 Feb 2007 19:24:28 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: GPL vs non-GPL device drivers
Cc: "v j" <vj.linux@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       "Dave Jones" <davej@redhat.com>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0702152025410.7391@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <Pine.LNX.4.62.0702152025410.7391@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, 15 Feb 2007, v j wrote:

> Personally, I see no real difference between EXPORT_SYMBOL and
> EXPORT_SYMBOL_GPL.
> If you derive from GPL'ed code, your code is a derived work.
---

I agree with you that there's no difference in law, though I think the
difference is that neither creates a derived work. "Derived work" is a
very vague notion in law, and the case law on this has varied over
time. I think it would be a real crap shoot for both sides to bring
this to court, at least in the US.

Note, though, that I DO support the OSS equation and believe that
companies *should not* use closed-source modules, whether it's legal
or not, except in the very specific case of code that also works with
other systems. I think this ethical imperative goes with the nature of
the author's gift to the community.

scott
