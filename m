Return-Path: <linux-kernel-owner+w=401wt.eu-S934639AbXGUGMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbXGUGMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXGUGMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:12:37 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49860 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXGUGMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:12:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=DLAN9fEWQCH2PyFzvMobqB4fpc/aEcn5zmndBgmWK+1q7t0yKlTAJ4RsSWnRS1rd1WO0exfLdBbjS9hhuIVGuBPxNqQlC5ImUk6WBYX6l3mp2OqBJB5f+TdzWv83EFOc;
Message-ID: <46A1A3D0.4010704@simon.arlott.org.uk>
Date: Sat, 21 Jul 2007 07:12:32 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org> <46A0F282.8070103@simon.arlott.org.uk> <20070720180019.GJ14791@parisc-linux.org>
In-Reply-To: <20070720180019.GJ14791@parisc-linux.org>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/07 19:00, Matthew Wilcox wrote:
> On Fri, Jul 20, 2007 at 06:36:02PM +0100, Simon Arlott wrote:
>> Mass
>> replacing any labels run through Lindent with space prefixes would seem
>> like a bad idea :/
> 
> We don't tend to mass-run code through Lindent.  This may or may not be
> a bad thing, but the fact is that it just doesn't happen.

I realise that, and it would be a big mess to do so - but when code is
run through it, it shouldn't modify existing good code into slightly
worse code.

-- 
Simon Arlott
