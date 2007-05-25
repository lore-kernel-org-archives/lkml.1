Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbXEYWq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbXEYWq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXEYWqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:46:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXEYWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:46:47 -0400
Message-ID: <46576752.4090607@zytor.com>
Date: Fri, 25 May 2007 15:46:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>	 <46572DAF.1000108@zytor.com>	 <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>	 <46573B23.1090700@zytor.com>	 <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>	 <4657589F.7050509@zytor.com>	 <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>	 <4657626B.7010204@zytor.com> <a781481a0705251535g27bd38a5s496cc7b44f2d45d5@mail.gmail.com>
In-Reply-To: <a781481a0705251535g27bd38a5s496cc7b44f2d45d5@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>>
>> Sorry to say, but weren't you the person who didn't recognize !! as the
>> idiomatic booleanizing operator?
> 
> Yes, of course, please prove a link / connection between that and this?
> 

Very simple: it shows a lack of understanding of idiomatic use of C.

	-hpa
