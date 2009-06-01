Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZFAH1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZFAH1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZFAH1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:27:36 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:50811 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZFAH1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DIVzOdLOCihfll8zz8PQYzKO7C7igB2gMFDzIpEbXgBF7s2NDVQni12lRa9F39mRV/
         OVwEgw13gSx2Hb6Fn1Pz3R6yzhgVYiAwkfA4SP8Psu4/IGEiSg3QI7Jixe+R+CM3go3/
         3yA8YVdFhHJ8h8u32IMdxOEwqkgCakg4wwdrI=
MIME-Version: 1.0
In-Reply-To: <d364733c0905312349m6b5c8664h6cc7701a576c6b7d@mail.gmail.com>
References: <d364733c0905312349m6b5c8664h6cc7701a576c6b7d@mail.gmail.com>
Date: Mon, 1 Jun 2009 15:27:37 +0800
Message-ID: <d82e647a0906010027qe1b3465we5724aa4ed35436@mail.gmail.com>
Subject: Re: new implementation of mutex
From: Ming Lei <tom.leiming@gmail.com>
To: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/1 Ð»¸Ù <xiegang112@gmail.com>:
> I debug it and find the debug_locks = 0.  Is this why there is no
> warning message and how turn it on? (I also had CONFIG_LOCKDEP_SUPPORT
> on.)

Please confirm CONFIG_PROVE_LOCKING is enabled.

Thanks,
-- 
Lei Ming
