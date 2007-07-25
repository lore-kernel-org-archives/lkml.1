Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXGYVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXGYVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXGYVMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:12:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbXGYVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:12:00 -0400
Message-ID: <46A7BC79.7020902@zytor.com>
Date: Wed, 25 Jul 2007 14:11:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, gregkh@suse.de
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com> <46A7B983.90407@googlemail.com> <46A7BB12.7060504@googlemail.com>
In-Reply-To: <46A7BB12.7060504@googlemail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
>>
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> c0202e73 00703601   R_386_32 c03071bc  _sdata
>>
>> $ grep c03071bc System.map
>> c03071bc R __tracedata_end
>> c03071bc A _sdata
> 

What is at 0xc0202e73?

	-hpa
