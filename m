Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbXJUV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbXJUV5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXJUV5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:57:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:31275 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXJUV5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BHoZjbmrCJiDH1jcA4F/oCZhwDCZUgqKSFNg2gr24CrPgnP350IdBSusKHbPG9M0JLaeLNfrbMJfJJJBSyIGMNE2Vue046kYRDWTgvFs1huJFdHu6pD7a6gjrDvfTN/W4bnKj6tW1ezW4GDvGX3WSK2ZWCNUPFKGBqsvwELUYQE=
Message-ID: <471BCB22.3000202@googlemail.com>
Date: Sun, 21 Oct 2007 23:56:50 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com> <471B2918.5090502@googlemail.com> <471B487C.5080209@googlemail.com> <471BA564.3040305@zytor.com> <20071021200214.GA6250@uranus.ravnborg.org> <471BC326.50400@googlemail.com> <471BC416.4090705@zytor.com>
In-Reply-To: <471BC416.4090705@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yeah, this is a VirtualBox problem.
> 
> At this point, this is clearly a matter for innotek, not for the 
> mainstream kernel development community.

Ok I will report that to Innotek , thanks for all the help and sorry for the noise.

> 
> 	-hpa
> 

Gabriel
