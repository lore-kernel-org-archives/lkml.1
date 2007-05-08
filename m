Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbXEHPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbXEHPpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968081AbXEHPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:32:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:58860 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966428AbXEHP2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:28:23 -0400
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       "Michael Jones" <mlj28@cam.ac.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org>
	<f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 17:28:21 +0200
In-Reply-To: <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com> (Alexey Zaytsev's message of "Tue, 8 May 2007 12:48:51 +0400")
Message-ID: <m3bqgv72sq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexey Zaytsev" <alexey.zaytsev@gmail.com> writes:

> I was always curious, why do people want to run ixp4xx in LE mode? What
> are the benefits that overweight the obvious performance degradation?

Debian is indeed a valid reason.
I wonder if it would be much work to create BE Debian as well.
Simple automated process it seems, for most part at least.
-- 
Krzysztof Halasa
