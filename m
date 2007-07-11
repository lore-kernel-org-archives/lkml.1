Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbXGKQM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbXGKQM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbXGKQMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:12:47 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:44096 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbXGKQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:12:46 -0400
Message-ID: <4695017A.6060606@kernel.org>
Date: Wed, 11 Jul 2007 09:12:42 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.4 (Macintosh/20070604)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Steve Beattie <sbeattie@suse.de>
Subject: Re: [PATCH 1/1] file capabilities: clear caps cleanup
References: <20070711141850.GA6690@sergelap.austin.ibm.com>
In-Reply-To: <20070711141850.GA6690@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Fine with me.

Cheers

Andrew

Serge E. Hallyn wrote:
>>From 88115394044e697ac852f7fb9f30483e87f4f598 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 11 Jul 2007 10:01:01 -0400
> Subject: [PATCH 1/1] file capabilities: clear caps cleanup
> 
> As suggested by Steve Beattie, rather than jump into a
> conditional block in certain cases, define and use a
> static inline bprm_clear_caps().

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGlQF6+bHCR3gb8jsRArmZAJ9Je0Da0SDtg78tx5ks7gvY/E5x/wCfYikC
bkD1uf7L3cdKzBMEvdjqB/c=
=/z3n
-----END PGP SIGNATURE-----
