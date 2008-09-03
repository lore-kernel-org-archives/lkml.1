Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYICTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYICTIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYICTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:08:39 -0400
Received: from mail.cavein.org ([66.245.249.51]:56180 "EHLO mail.cavein.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbYICTIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:08:38 -0400
X-Greylist: delayed 787 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 15:08:37 EDT
X-DKIM: Sendmail DKIM Filter v2.6.0 smtp.cavein.org m83IsaJ5026451
X-DomainKeys: Sendmail DomainKeys Filter v1.0.0 smtp.cavein.org m83IsaJ5026451
DomainKey-Signature: a=rsa-sha1; s=2008; d=cavein.org; c=nofws; q=dns;
	h=date:from:to:cc:subject:in-reply-to:message-id:references:
	user-agent:mime-version:content-type;
	b=eMHuf1704Q6DFosfMm6ybs42goM2GnvAxI2MeCGY05uHss+GB37vhBpr7bd0WE0Ni
	kNPxHgQBOsG8XvIllQnnyicMwiSewHek9aXhhSCbOKTlJKpamc8fh7TKNzd9wkW3Obn
	5ORxup5i/vdJS/d8g/7CaJUHljeSePiWYzGRHEE=
Date: Wed, 3 Sep 2008 11:54:36 -0700 (PDT)
From: Richard A Nelson <cowboy@cavein.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, torvalds@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
In-Reply-To: <20080903144834.35276de7@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0809031151200.742@hygvzn-guhyr.pnirva.bet>
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk> <48BDCF09.7000603@garzik.org> <20080903142941.3f25d235@lxorguk.ukuu.org.uk> <20080903144834.35276de7@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (smtp.cavein.org [127.0.0.1]); Wed, 03 Sep 2008 18:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Alan Cox wrote:

> We can't automate that for the other devices as we don't actually know
> how to check the PATA port on them.

I happen to have one of the others:
 	Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b1)

It is not in use, likely as a result of the issues at hand, I don't
recall exactly what transpired at the time.

I have no specs, but would be happy to run any software diagnostics
if they'd be of help
-- 
Rick Nelson
"I would rather spend 10 hours reading someone else's source code than
10 minutes listening to Musak waiting for technical support which isn't."
(By Dr. Greg Wettstein, Roger Maris Cancer Center)
