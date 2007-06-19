Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXFSRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXFSRLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXFSRLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:11:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:49806 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbXFSRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:11:38 -0400
Date: Tue, 19 Jun 2007 19:10:54 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: Bodo Eggert <7eggert@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Behdad Esfahbod <behdad@behdad.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070619144230.GA14609@uhulinux.hu>
Message-ID: <Pine.LNX.4.58.0706191906410.4651@be1.lrz>
References: <8aT6Q-3iM-17@gated-at.bofh.it> <8xLa7-25v-5@gated-at.bofh.it>
 <E1I0eAW-0000nC-5a@be1.lrz> <20070619144230.GA14609@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+ejPKg20wNAnbG8PHYDjCkrUMJiOmzUI/77Fu
 rVm300q8DvM5wV1dnUfdv70tX1/seCRGZZAYEBx7OHZOqbk2cU
 qfQCpuESID1pCnB0Z+09w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Egmont Koblinger wrote:
> On Tue, Jun 19, 2007 at 03:54:52PM +0200, Bodo Eggert wrote:
> 
> > Does the FLUSH DTRT by design, or does it just shrink and hide the original
> > race?

<long snip>

> But you may be right: yes, it might be a bug (or misfeature) in the FB code,
> too. Could you please look after it? I don't think I'd be able to do it and
> have time for this.

I have neither the insight nor the time to do that. I just read the bug 
description and drew my conclusions.
-- 
Never stand when you can sit, never sit when you can lie down, never stay
awake when you can sleep.
