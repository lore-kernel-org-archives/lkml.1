Return-Path: <linux-kernel-owner+w=401wt.eu-S1763793AbXGJJlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763793AbXGJJlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbXGJJkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:40:53 -0400
Received: from procserver.webwayone.co.uk ([62.8.115.202]:4501 "EHLO
	procserver.webwayone.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757527AbXGJJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:40:52 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 05:40:52 EDT
X-DKIM: Sendmail DKIM Filter v1.2.0 procserver.webwayone.co.uk l6A9JYt5018403
DomainKey-Signature: a=rsa-sha1; s=procserver; d=webwayone.co.uk; c=nofws; q=dns;
	h=x-dkim:from:to:subject:references:x-hashcash:date:
	in-reply-to:message-id:user-agent:mime-version:content-type:
	x-spam-status:x-scanned-by;
	b=RYJBFg/u8pXSSuI0Jok/FlXKcBbITMAYtaUfHV2LAy/zmhxodKOoIP0D7glp9oVyv
	rUatRmUDn7u5vxtBB1arg==
X-DKIM: Sendmail DKIM Filter v1.2.0 procserver.webwayone.co.uk l6A9JYt5018403
From: Graham Murray <gmurray@webwayone.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Specialix SX cards not detected in kernels >=2.6.20
References: <13055248471022532464@wsc.cz>
X-Hashcash: 1:20:070710:linux-kernel@vger.kernel.org::lJgKfX0edV5QarGJ:0000000000000000000000000000000008tWd
Date: Tue, 10 Jul 2007 10:19:34 +0100
In-Reply-To: <13055248471022532464@wsc.cz> (Jiri Slaby's message of "Tue, 10
	Jul 2007 09:17:06 +0200 (CEST)")
Message-ID: <7wzm24sjix.fsf@gmdev.webwayone.co.uk>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1.50 (i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> In switched ids. Could you try the patch below?

Thanks. That fixed the problem - the card works again now.
