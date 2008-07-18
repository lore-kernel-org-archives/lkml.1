Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbYGRTN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbYGRTN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYGRTNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:13:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:15826 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYGRTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M33YWbeDagpTvLKdtJel8rcvkJi+4LFHMzaCU74IEb+HAueQdC9spiY+onA9oOouYi
         3be42JKGflFL3jVj//MeQ4yusF4z3XFbJwg4Ka9S52EoNz4UumQsmraWVlpaDmRBF2m7
         aweye7iCb0hEhAFIOK/b79iCL8n5/pm2kdpiQ=
Date: Fri, 18 Jul 2008 23:13:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
Message-ID: <20080718191343.GG6897@asus>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus> <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com> <20080718174931.GE6897@asus> <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Jul 18, 2008 at 08:09:20PM +0100]
| On Fri, 18 Jul 2008, Cyrill Gorcunov wrote:
| 
| > iirc, they all were there (though some error codes are specific for
| > particular processor classes like P4, pentium and other - don't remeber
| > you could check intel dev manual for this).
| 
|  This is an error in some newer Intel documents -- the set of supported
| bits is the same for all APICs implementing the ESR register and the error
| interrupt (the 82489DX is the one to provide neither).
| 
|   Maciej
| 

thanks, Maciej

		- Cyrill -
