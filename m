Return-Path: <linux-kernel-owner+w=401wt.eu-S1767461AbXDFBGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767461AbXDFBGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767468AbXDFBGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:06:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767461AbXDFBGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:06:30 -0400
Message-ID: <46159D08.9030400@zytor.com>
Date: Thu, 05 Apr 2007 18:06:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Define EFLAGS_IF
References: <1174533374.2713.104.camel@localhost.localdomain> <46159256.1040705@zytor.com> <461592AA.4060103@goop.org> <46159480.20108@zytor.com> <20070406004839.GA27668@one.firstfloor.org>
In-Reply-To: <20070406004839.GA27668@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> No processor.h is such a hodgepodge of unrelated stuff that any
> splitting up is a good thing.
> 

Fair enough.  However, I'd still like to see the X86_CR* constants 
moved, too (and constants added for at least CR0 as well.)

	-hpa
