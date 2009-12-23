Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZLWQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZLWQaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZLWQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:30:25 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40559 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZLWQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:30:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bFUgwsrP+UcXXIrM5i2ki72xkuHiOq4weMRQYNSvQMyzJG8sbnVxm8QQ/iqc6H43nv
         XG3YFwOIWorXWv38cOBUi57xQ0j3yXYukuGcbQRe5mevG+M02GRsNxv9rEEP2LYHNTD/
         pTDhoPkMWq6jou3+CFyATltqCu0t7cpEPnNp8=
Message-ID: <4B324599.1030302@gmail.com>
Date: Wed, 23 Dec 2009 17:30:17 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Andrey Rahmatullin <wrar@wrar.name>
CC: Roger Luethi <rl@hellgate.ch>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: via_rhine kernel crashes in 2.6.32
References: <20091222152658.GA16043@core.hellgate.ch> <20091223095203.GA7824@ff.dom.local> <20091223162117.GA4919@wrars-comp.wrarsdomain>
In-Reply-To: <20091223162117.GA4919@wrars-comp.wrarsdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Rahmatullin wrote, On 12/23/2009 05:21 PM:

> On Wed, Dec 23, 2009 at 09:52:03AM +0000, Jarek Poplawski wrote:
>> BTW, it seems a change in 2.6.31 might trigger these timeouts more
>> often than before. Andrey, could you try if this matters here?
> They appear once per 4 seconds with or without this patch.
> 

OK, thanks for checking this.

Jarek P.
