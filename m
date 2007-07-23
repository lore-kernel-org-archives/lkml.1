Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXGWCpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXGWCpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 22:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbXGWCpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 22:45:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:9390 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbXGWCpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 22:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ISD2qF3WOafeyDr2TsVzGGe8GaBrWAE2YR05wyaFeErNlrwqkd8jmPHU1sv1cu/uNn2VRymUCM5uIifaKWc8YgdUjB7byQ8iANAoYWxGZ368hQZcd6bJ29vAG4cq1O/n/L1P0xJo2EikrsNN7Dy2LWGVB+C95F/dArMSImQ4vO0=
Message-ID: <46A415A4.90009@googlemail.com>
Date: Mon, 23 Jul 2007 04:42:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <46A40BC7.9030209@googlemail.com>
In-Reply-To: <46A40BC7.9030209@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
[ fixed CC , sorry to that ]

> Linus Torvalds wrote:
>> Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.
> 
> 
> ...
> 
> drivers/char/hpet.c:76: warning: integer constant is too large for 'long' type
> 
> ...
> 
> Introduced by 0aa366f351d044703e25c8425e508170e80d83b1 
> 
> 
> 
> 
> 
