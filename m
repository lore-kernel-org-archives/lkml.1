Return-Path: <linux-kernel-owner+w=401wt.eu-S967149AbXJSVYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967149AbXJSVYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966050AbXJSVYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:24:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:20335 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761208AbXJSVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gXno3FJEDkQ/X/YYXzIPyd2AKMeCFe0DDKgyg5pgh1fVctjP0DxZy+linNb7XNDZN8R15j1Ip6wGUjLT06T2bdEQx8jq52e6CwzOOlmLcVVq02v5na8fLOQTvi7FAOW1QCOTfl17yY3d3LiPLLKhryGpDZwQhoTziLazR03nr6o=
Message-ID: <47191F6C.2040801@googlemail.com>
Date: Fri, 19 Oct 2007 23:19:40 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote: 
> Trying 'make mrproper' first has high chances of fixing this I'd guess.

Is what I did before latest pull. 

Maybe this whole tree got broken. I'll try a fresh one and report back.


Regards ,

Gabriel
