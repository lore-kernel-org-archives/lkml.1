Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXIPUrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXIPUrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXIPUqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:46:54 -0400
Received: from mxintern.schlund.de ([212.227.126.204]:58016 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXIPUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:46:53 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2007 16:46:53 EDT
Date: Sun, 16 Sep 2007 22:39:26 +0200
From: Hannah Schroeter <hannah@schlund.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070916203926.GA17863@schlund.de>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916195909.GA18232@stusta.de>
Organization: Schlund + Partner AG
X-UI-Msg-Verification: f95605943fdd38b6e96a8e610e3165a9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sun, Sep 16, 2007 at 09:59:09PM +0200, Adrian Bunk wrote:
>On Sun, Sep 16, 2007 at 11:48:47AM -0700, Can E. Acar wrote:
>>...
>> First, these developers got questionable advice from senior Linux kernel
>> developers, and SLFC (which is closely related to FSF) in the process.

>The most questionable legal advice in this thread was by Theo de Raadt 
>who claimed choosing one licence for _dual-licenced_ code was illegal...

JFTR, I do *not* think that that assessment was questionable. Unless the
dual-licensing *explicitly* allows relicensing, relicensing is forbidden
by copyright law. The dual-licensing allows relicensing only if that's
*explicitly* stated, either in the statement offering the alternative, or
in one of the licenses.

Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.

If you think that's questionable, you should at least provide arguments
(and be ready to have your interpretation of the law and the licenses
tested before court).

>[...]

>Regarding ethics - if you use the BSD licence for your code you state in 
>the licence text that it's OK that I take your code and never give 
>anything back.

But the BSDl does not allow you to relicense the original code, even
while it allows you to license copyrightable additions/modifications
under different terms with few restrictions.

However, you say "regarding ethics" and just go back to the legal level.
Is it really ethical, if you consider both Linux and OpenBSD part of one
OSS "community", to share things only in one direction? To take the
reverse engineered HAL but to not allow OpenBSD to take some
modifications back?

>[...]

>Some people have the funny position of opposing the GPL which enforces 
>that you have to give back, but whining that people took their BSD 
>licenced code and don't give back.

A difference is, GPL requires it under every circumstance. BSD does not,
indeed. But how should one expect it from *OSS* people that even *they*
don't give back? Do you really want to put yourself on the same level as
closed-source companies?

>[...]

Kind regards,

Hannah.
