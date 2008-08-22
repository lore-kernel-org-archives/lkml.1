Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYHVTTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYHVTTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYHVTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:18:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYHVTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:18:58 -0400
Message-ID: <48AF10FD.2000209@zytor.com>
Date: Fri, 22 Aug 2008 12:18:21 -0700
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
> 
>  I'm running Mandriva's VirtualBox 1.6.4 OSE, my host kernel is 2.6.26-3mnb
> (patched).
> 

What is your host *system* like -- CPU especially, and is your host 
kernel 32 or 64 bits?

	-hpa
