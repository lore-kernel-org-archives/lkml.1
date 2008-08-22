Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYHVUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYHVUcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHVUca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYHVUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:32:30 -0400
Message-ID: <48AF2235.7080906@zytor.com>
Date: Fri, 22 Aug 2008 13:31:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>	<48ADDF4F.2020401@zytor.com>	<48AE5FCF.6030103@zytor.com>	<20080822065012.GV14110@elte.hu>	<20080822113941.147a1db0@doriath.conectiva>	<20080822153451.GA8390@Krystal>	<20080822132948.57e47076@doriath.conectiva>	<20080822163520.GA9860@Krystal>	<20080822142054.403cbdef@doriath.conectiva>	<48AF014D.8040103@zytor.com> <20080822164023.7060137e@doriath.conectiva>
In-Reply-To: <20080822164023.7060137e@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> 
> | 2. a patch against -linus for testing.
> 
>  I have tried this patch with Linus tree early today, should I try
> it with Ingo's tree too?
> 

It doesn't apply to tip.  This did not fix the problem?

	-hpa
