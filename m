Return-Path: <linux-kernel-owner+w=401wt.eu-S968460AbXFHKNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968460AbXFHKNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967577AbXFHKNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:13:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967664AbXFHKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:13:05 -0400
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070608012534.GB23290@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu>
	 <m3wsyfzcpt.fsf@maximus.localdomain>
	 <200706072232.37051.s0348365@sms.ed.ac.uk>
	 <m3sl93zagi.fsf@maximus.localdomain> <4668AC10.9060305@zytor.com>
	 <20070608012534.GB23290@havoc.gtf.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:11:53 +0200
Message-Id: <1181297513.7348.287.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 21:25 -0400, Jeff Garzik wrote:
> On Thu, Jun 07, 2007 at 06:08:32PM -0700, H. Peter Anvin wrote:
> > My big concern with the 80-column rule is that it discourages commenting.
> 
> My concern with that logic is that encourages random, super-wide code
> lines that varies with each coder.  You are left to the mercy of he with
> the widest text window.

I just counted, I can get 380 chars on 1 screen, if I let it straddle
the two monitors I have then I can get 760 chars.

> The 80-column rule is good as a general guideline, though there are
> obvious exceptions.  Comments IMO are not one of them.  That rapidly
> creates unreadable code.

I agree, its easier on the eyes to have dense columns of text to read
than having to scan all over the place. More so, its more economical of
screen-estate as well, a few long lines take up valuable space which
could otherwise have been used to create more columns (yes, from the guy
sitting behind the two 24" screen).

I usually work with 4 columns side by side per screen, that gives me
about 92x110 columns. Its easy on they eye (it need not wander all over
the place to read stuff) and it can handle the occasional line that
exceeds 80 chars (they never exceed very far - yes there are
exceptions :-( )



