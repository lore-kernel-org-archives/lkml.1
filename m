Return-Path: <linux-kernel-owner+w=401wt.eu-S1765835AbXJQNCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765835AbXJQNCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXJQNBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:01:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:50857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757655AbXJQNBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:01:51 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18REkYiy68R3u5+dwGzKTdswvxjWjLW/FEULREpeH
	iuJW515PxJSBFn
Date: Wed, 17 Oct 2007 15:01:45 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com, nick.cheng@areca.com.tw
Subject: Re: arcmsr changelog differs from diffs
Message-ID: <20071017130145.GA15918@atjola.homenet>
References: <200710170007.20454.hpj@urpla.net> <20071017005342.GA14212@atjola.homenet> <200710171241.12575.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710171241.12575.hpj@urpla.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On 2007.10.17 12:41:11 +0200, Hans-Peter Jansen wrote:
> Dear Björn,
> 
> Am Mittwoch, 17. Oktober 2007 02:53 schrieb Björn Steinbrink:
> > And then, if I may guess, James probably just noticed that there were
> > changes left and commited them (while they were now down to just the
> > whitespace change), without checking what changes were actually left (no
> > offense intended). At least I think that git wouldn't cripple the diff
> > if the changes that James checked in were not already whitespace-only at
> > the time he commited them, and the git history of his tree seems to
> > agree.
> 
> (*) Thanks for the clarification, Björn. What made me stumbling was the 
> different orginators, while Jeff isn't known with catching attention by 
> assimilating other peoples contributions. 

I'm just guessing here, and certainly don't want to blame anyone, but
Jeff's original patch was from July, while the only date I can find for
Nick's commit is September 13th. So it was probably Nick who integrated
Jeff's changes into his commit (maybe thinking that Jeff's patch got
lost), not Jeff assimilating a subset of Nick's changes.

Björn
