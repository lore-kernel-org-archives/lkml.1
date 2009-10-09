Return-Path: <linux-kernel-owner+w=401wt.eu-S1760571AbZJIJbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571AbZJIJbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760562AbZJIJbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:31:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:34945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760560AbZJIJbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:31:21 -0400
X-Authenticated: #46697607
X-Provags-ID: V01U2FsdGVkX1+15eUQrPC1ZdMDWbMxnt/x3symY3hEktK33kYrwQ
	J8fGl1Pnz3HFEE
From: Egon Alter <egon.alter@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Microsoft is planning Windows 8 to be 128-bit
Date: Fri, 9 Oct 2009 11:30:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc3-00077-gc1176d6; KDE/4.3.1; x86_64; ; )
References: <f188924b0910081605i6f5cc1c3ibb4cfe6b17543521@mail.gmail.com> <3e8340490910081620s4f259320h583b91192c4ab88e@mail.gmail.com> <1255074577.26976.355.camel@twins>
In-Reply-To: <1255074577.26976.355.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910091130.32906.egon.alter@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Thu, 2009-10-08 at 19:20 -0400, Bryan Donlan wrote:
> > The CPU architecture would have to exist first (it doesn't)
> 
> And here I was going to ask Fred to send me such a machine so that I
> could port Linux for him ;-)

I think, what was meant here is the 128-bit (sse) and 256-bit (avx) vector 
extentions of current and future processors. So if you want to run a small 
kernel on your graphics card and/or on some vector units inside the main cpu, 
128 and 256 bit registers are required.

Egon
