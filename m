Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZEEUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZEEUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZEEUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:15:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZEEUPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:15:40 -0400
Message-ID: <4A009E34.10006@suse.com>
Date: Tue, 05 May 2009 16:14:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] reiserfs xattr fixups
References: <20090505193014.926371851@suse.com> <20090505201305.GM8633@ZenIV.linux.org.uk>
In-Reply-To: <20090505201305.GM8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> On Tue, May 05, 2009 at 03:30:14PM -0400, Jeff Mahoney wrote:
>>  This series consists of three patches:
>>
>>  1) rework the bit of locking after Al's privroot lookup patch
>>  2) Fix up security xattrs so they don't apply to other xattrs
>>  3) Clean up the privroot hiding since we now cache the privroot early
> 
> Applied and pushed to for-next

Thanks.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoAnjQACgkQLPWxlyuTD7L6/gCfWy7fkY4B9wHyGmQZm4oZB0AG
udwAoI9+kobU+lNPPmBhJRXZ/F9ffSyQ
=EUQL
-----END PGP SIGNATURE-----
