Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbXGYVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbXGYVQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXGYVQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:16:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:21489 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXGYVQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=df1rDFxVmWqt5W4Rni9mpZKl6TJTBAXSMV0sE93fSuiQytM2Ocew8aMY8SpqTVnMw85Q7IcTEaJYFLqPI7qmbOWNSI9PRgYl6wOnGGoetcGmevOyFnkyqIzE1J3rvcpcPkCctex/+hvZiLuyC1xCIjja4jLmSdmVw5qBSREb7lw=
Message-ID: <46A7BCE3.3040709@googlemail.com>
Date: Wed, 25 Jul 2007 23:13:07 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, gregkh@suse.de
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com> <46A7B983.90407@googlemail.com> <46A7BB12.7060504@googlemail.com> <46A7BC79.7020902@zytor.com>
In-Reply-To: <46A7BC79.7020902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Gabriel C wrote:
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c0202e73 00703601   R_386_32 c03071bc  _sdata
>>>
>>> $ grep c03071bc System.map
>>> c03071bc R __tracedata_end
>>> c03071bc A _sdata
> 
> What is at 0xc0202e73?

grep returns nothing for 0xc0202e73

> 
> 	-hpa
> 

Gabriel
