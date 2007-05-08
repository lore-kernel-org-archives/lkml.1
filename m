Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXEHRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXEHRU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXEHRU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:20:56 -0400
Received: from khc.piap.pl ([195.187.100.11]:44168 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXEHRUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:20:55 -0400
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       Michael Jones <mlj28@cam.ac.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org>
	<f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
	<m3bqgv72sq.fsf@maximus.localdomain>
	<20070508155201.GA1251@xi.wantstofly.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 19:20:54 +0200
In-Reply-To: <20070508155201.GA1251@xi.wantstofly.org> (Lennert Buytenhek's message of "Tue, 8 May 2007 17:52:01 +0200")
Message-ID: <m3hcqn5j0p.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek <buytenh@wantstofly.org> writes:

> There _is_ an ARM BE version of Debian.
>
> It's not an official port, but it's not maintained any worse than
> the 'official' LE ARM Debian port is.

Hmm... That changes a bit. Perhaps we should forget about
that LE thing then, and (at best) put that trivial workaround?
-- 
Krzysztof Halasa
