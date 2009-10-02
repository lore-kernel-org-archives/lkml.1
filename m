Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZJBOFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZJBOFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZJBOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:05:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:38608 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZJBOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zw2FURC+rqpQgMDn/2WTG3rT6Ke9B2/wuTfyQX9vtgAyEGai+gUxXeNYsaWXHrXNqO
         /lx++yR7AEFVFWoeVR0EKFXoBvdqo/QvQqXups4Oq8pGwKvOfDQpjJ8knnQEhXjivvBA
         Hnz8UB0XPSq22bNaPXmfN2xmYU1CJbLmHIIlY=
Date: Fri, 2 Oct 2009 18:05:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
Message-ID: <20091002140512.GA5645@lenovo>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.7sH.xMTxKB@chimera> <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com> <4AC5C42E.9070909@msgid.tls.msk.ru> <4AC5D810.3080307@msgid.tls.msk.ru> <aa79d98a0910020355r31b37ea0v1fef7286f7a71508@mail.gmail.com> <4AC5DCFD.4010107@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC5DCFD.4010107@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Michael Tokarev - Fri, Oct 02, 2009 at 02:59:09PM +0400]
...
>
> Please hold on for a while.
>
> I switched to BZIP2, it booted fine.  I switched back to LZMA -
> and that one now boots too.  Original bzImage, which were built
> by the same compiler from the same source using the same
> options reboots.
>
> So um... I'm now trying to reproduce it ;)
>
> /mjt
>

ok, perhaps it was indirect error or cosmic rays

	-- Cyrill
