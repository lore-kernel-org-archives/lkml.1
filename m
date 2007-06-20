Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbXFTUF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbXFTUF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbXFTUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:05:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:21990 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388AbXFTUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p5NDyIYrPH6EAHze5mfmeHJpEYrigjKEC6Rs+KSbjPUk658/qxwJw+mxCg/vtqqn5qsIC712Dnyx43IL8aqmw2Trv7eXwGWHPNTw95oo7Xc6UzeIy2RR2/roXb4713j0WLMJDJwJgcQ5WkKVQwKU2nyWr/Tqlu/N7DuTEuc700M=
Message-ID: <161717d50706201305v5bd3379cx2d397589a1fe0b00@mail.gmail.com>
Date: Wed, 20 Jun 2007 16:05:16 -0400
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: "david@lang.hm" <david@lang.hm>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Michael Poole" <mdpoole@troilus.org>,
       "Tomas Neme" <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	 <871wg6trnx.fsf@graviton.dyn.troilus.org>
	 <2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
	 <87wsxysaad.fsf@graviton.dyn.troilus.org>
	 <Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
	 <87odjas9f7.fsf@graviton.dyn.troilus.org>
	 <Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
X-Google-Sender-Auth: 1baaa3a9c6c43669
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, david@lang.hm <david@lang.hm> wrote:
>
> but the signature isn't part of the kernel

But some would argue that it's part of the source with which the
binary is derived (only a court could meaningfully decide if they're
right).

> and the code that checks the
> signature is completely independant.

Irrelevant.

> and finally the PVR functions are not
> part of the kernel

Booting is.

Dave
