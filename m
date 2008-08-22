Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYHVTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYHVTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYHVTOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:14:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbYHVTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:14:42 -0400
Message-ID: <48AF0FF9.7050007@zytor.com>
Date: Fri, 22 Aug 2008 12:14:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>	<48ADDF4F.2020401@zytor.com>	<48AE5FCF.6030103@zytor.com>	<20080822065012.GV14110@elte.hu>	<20080822113941.147a1db0@doriath.conectiva>	<20080822153451.GA8390@Krystal>	<20080822132948.57e47076@doriath.conectiva>	<48AEF457.5020100@zytor.com> <20080822161040.27c68cf0@doriath.conectiva>
In-Reply-To: <20080822161040.27c68cf0@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> Em Fri, 22 Aug 2008 10:16:07 -0700
> "H. Peter Anvin" <hpa@zytor.com> escreveu:
> 
> | So, Luiz: the DEBUG_INFO version of vmlinux would be helpful.  It would 
> | also help to know the exact version of VirtualBox you're running, what 
> | source you got it from, and what your host system looks like.
> 
>  You will find vmlinux with DEBUG_INFO enabled at:
> 
> http://users.mandriva.com.br/~lcapitulino/virtualbox-oops/
> 
>  I'm running Mandriva's VirtualBox 1.6.4 OSE, my host kernel is 2.6.26-3mnb
> (patched).
> 
>  I could try with upstream's VirtualBox just to be sure it's not
> something else, but I don't think it is since there are reports for
> ArchLinux and Ubuntu as well:
> 
> https://bugs.launchpad.net/ubuntu/intrepid/+source/linux/+bug/246067
> 

Not necessary, but I wanted to get the information so I can try to 
reproduce locally.

	-hpa
