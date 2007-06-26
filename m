Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbXFZWQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbXFZWQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXFZWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:16:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXFZWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:16:46 -0400
Message-ID: <46819074.1000503@suse.com>
Date: Tue, 26 Jun 2007 18:17:24 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Danillo Aquino <danillo.aquino@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Options.
References: <8277674d0706260701u3abac42eh817b72fa095e2756@mail.gmail.com> <8277674d0706260702p4c750351gc1e9458ea1eadc36@mail.gmail.com>
In-Reply-To: <8277674d0706260702p4c750351gc1e9458ea1eadc36@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Danillo Aquino wrote:
> Which patch necessary to qualify the following options in kernel, I am
> using kernel 2.6.17
> 
> IP: DHCP support
> Root file system on NFS

Patches shouldn't be necessary for either of these features.

Check out Documentation/nfsroot.txt.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGgZB0LPWxlyuTD7IRAiGxAKCgvUOCkf5nTsxnWb7ZXk4rD70PjACfdWPb
NgG6bIdZlLJqgQmAtMb05KI=
=cAOo
-----END PGP SIGNATURE-----
