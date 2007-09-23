Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbXIWAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbXIWAlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXIWAlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 20:41:04 -0400
Received: from smtpoutm.mac.com ([17.148.16.78]:57735 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXIWAlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 20:41:03 -0400
In-Reply-To: <1190506383.30132.11.camel@localhost>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> <1190506383.30132.11.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BD6BFDD9-65C4-4780-BAF8-975A5A25913C@mac.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Sat, 22 Sep 2007 20:40:07 -0400
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 22, 2007, at 20:13:03, Joe Perches wrote:
> On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
>> Additionally, this would allow the compiler to completely optimize  
>> out calls that are below a certain log-level severity level [2][3].
>
> Severity doesn't really equate to desire to log.  I'd prefer  
> arbitrary control of log levels.

Umm, actually... Severity is *exactly* "desirability of logging".  If  
you find any place that's otherwise then please provide patches to  
fix it (or at least notify the maintainer with a useful bug report  
and reasoning.

Cheers,
Kyle Moffett

