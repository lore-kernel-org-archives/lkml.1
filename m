Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbXKLQ3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbXKLQ3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXKLQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:28:58 -0500
Received: from smtp02.cdmon.com ([212.36.74.229]:62326 "EHLO smtp02.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXKLQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:28:58 -0500
Date: Mon, 12 Nov 2007 17:30:16 +0100
From: DervishD <lkml@dervishd.net>
To: Benny Halevy <bhalevy@panasas.com>
Cc: James Courtier-Dutton <James@superbug.co.uk>,
       Xavier Bestel <xavier.bestel@free.fr>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
Message-ID: <20071112163016.GC1073@DervishD>
Mail-Followup-To: Benny Halevy <bhalevy@panasas.com>,
	James Courtier-Dutton <James@superbug.co.uk>,
	Xavier Bestel <xavier.bestel@free.fr>,
	lkml <linux-kernel@vger.kernel.org>
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv> <20071110165017.GB16090@DervishD> <4736CA1D.9020507@superbug.co.uk> <47380B14.3010604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47380B14.3010604@panasas.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Benny :)

 * Benny Halevy <bhalevy@panasas.com> dixit:
> Using only spaces as DervishD suggested works around that using brute
> force by forcing the user to the author's preference which is
> legitimate but may not be the most productive way.

I admit it.

> I think that my proposal of using tabs as logical indents only (as Xav
> put it) and spaces for decorative alignment provides the best of both
> worlds.

Yes, you're right, and it is the only "mix" of tabs and spaces that
won't cause headaches. I still don't like tabs for indenting but that's
a matter of personal taste. Sometimes I use tabs for indenting when I
have to share code.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
