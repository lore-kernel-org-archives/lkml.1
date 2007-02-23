Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXBWU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXBWU5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbXBWU5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:57:20 -0500
Received: from mail.astral.ro ([193.230.240.11]:60216 "EHLO mail.astral.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXBWU5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:57:20 -0500
Message-ID: <45DF552C.6070702@astral.ro>
Date: Fri, 23 Feb 2007 22:57:16 +0200
From: Gergely Imre <imre.gergely@astral.ro>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, hancockr@shaw.ca
Subject: Re: irq balancing question
References: <45DED0D6.1040700@astral.ro>	 <1172241917.3241.4.camel@laptopd505.fenrus.org>	 <45DF012D.3080802@astral.ro>	 <1172246085.3241.24.camel@laptopd505.fenrus.org>	 <45DF3795.3040005@astral.ro> <1172257289.3241.48.camel@laptopd505.fenrus.org>
In-Reply-To: <1172257289.3241.48.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Arjan van de Ven wrote:
>> and i guess it doesn't matter if the distribution is being done by the
>> hardware, from the point of view of the kernel, i would still get the
>> performance penalty.
> 
> for the cache bouncing you save assuming you have an Intel cpu (eg one
> where the cache is shared). You don't save on the cross-cpu reassembly,
> that is an entire different algorithm path you hit there..
> 
> 
> 
>> i'm just trying to figure it out, i have no real knowledge of the inner
>> kernel workings, so i dont know. but i really would like to use all 4 cores.
>> just how expensive is that reassembly path ?
> 
> depends on your traffic to be honest, probably a question more suited
> for net-dev list.
> 

i'll look into it, thanks a lot for the comments.
