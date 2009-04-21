Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZDULwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZDULwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZDULwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:52:05 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45982 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbZDULwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:52:04 -0400
Date: Tue, 21 Apr 2009 13:51:54 +0200
From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: VIA Padlock driver no longer loads automatically
Message-ID: <20090421115154.GA25685@Chamillionaire.breakpoint.cc>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com> <20090421055331.GA14062@gondor.apana.org.au> <20090421055613.GA14319@gondor.apana.org.au> <20090421082645.GA22102@Chamillionaire.breakpoint.cc> <20090421105327.GA17166@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090421105327.GA17166@gondor.apana.org.au>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Herbert Xu | 2009-04-21 18:53:27 [+0800]:

>It was already renamed in the original patch.  The problem here
>is that padlock-aes was incorrectly renamed as it doesn't require
>a fallback.

Right, just key computation which is not part of the crypto API.

>Cheers,
>-- 

Sebastian
