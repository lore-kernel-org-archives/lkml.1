Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXGUGLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXGUGLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXGUGLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:11:08 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49856 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXGUGLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:11:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=bzvFbvdVrgYtuiUHNpGKGastw5FUDj8jsm2ZZHjAIFFVL0SS6Gfv4VZfq72loAEbtveD2w6lqv6Zj/kTGc1FxPvvlOk/X493FIbg1WevZ65G1ngyrn7lcUPZtyo2dr2E;
Message-ID: <46A1A375.3020900@simon.arlott.org.uk>
Date: Sat, 21 Jul 2007 07:11:01 +0100
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
>> On 20/07/07 18:07, Matthew Wilcox wrote:
>> > sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
>> > 
>> > which will replace the leading tabs and spaces with one space.
>> 
>> ... isn't the space thing a workaround for a "diff -p" bug?
> 
> Yes.  I like not being affected by bugs.  If you prefer to be affected
> by bugs, that's up to you.

Changing the code to fix a utility bug is madness. I think it's been
fixed too...

-- 
Simon Arlott
