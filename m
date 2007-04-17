Return-Path: <linux-kernel-owner+w=401wt.eu-S1031179AbXDQQ52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031179AbXDQQ52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031189AbXDQQ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:57:28 -0400
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:2979 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031179AbXDQQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:57:28 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ZFS with Linux: An Open Plea
Date: Tue, 17 Apr 2007 17:57:11 +0100
User-Agent: KMail/1.9.5
Cc: Tomasz =?utf-8?q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl> <20070417154814.632da1d9@the-village.bc.nu>
In-Reply-To: <20070417154814.632da1d9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171757.12070.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 15:48, Alan Cox wrote:
> > So who is responsible for potential changing Linux code licensing for
> > allow if not incorporate CDDL code correct interraction without breaking
> > some law ?
>
> Every single contributor, individually. Which won't happen.
>
> The real test of whether Sun were serious about ZFS being anywhere but
> Solaris is what they do to license it - they've patented everything they
> can, and made the code available only under licenses incompatible with
> other OS products. Their intent is quite clear, and quite sad.

This isn't universally true. Look at Java, for example, which Sun recently 
released parts of under an open source license -- not the CDDL, not a 
CDDL/xxx dual license, the GPL proper.

Indeed, Sun already have products that are dual licensed CDDL/GPL, for example 
the J2EE product.

> If Sun want ZFS to get used all over the place in free software then I'd
> have expected at the very least to see them throw out a copy of the code,
> docs and patent grant in a form that could be used, even if it came with
> no other assistance of any kind.

I couldn't speculate on the rationale, but it does seem that Sun's choice to 
use _only_ the CDDL with certain software (like ZFS) is deliberate.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
