Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXDLMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXDLMk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbXDLMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:40:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbXDLMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:40:58 -0400
Date: Thu, 12 Apr 2007 14:40:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Tasos Parisinos <t.parisinos@sciensis.com>,
       Bill Davidsen <davidsen@tmr.com>, Andi Kleen <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Message-ID: <20070412124054.GA563@one.firstfloor.org>
References: <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com> <4616BC09.2080509@tmr.com> <4152.81.207.0.53.1175900790.squirrel@secure.samage.net> <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1> <1349.81.207.0.53.1176302225.squirrel@secure.samage.net> <000401c77cdd$5ef79910$0864a8c0@scs1> <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com> <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps, with that in mind, it's better to not merge the bare RSA version either,
> as it might give false hope for more, because it looks like most implementations
> should be done in user space (either because that's better anyway, or because of
> legal reasons).

Before merging anything there would need to be clear applications
(with patches, discussions etc.) 

In general code with no users is not merged because it will just bitrot.

-Andi

