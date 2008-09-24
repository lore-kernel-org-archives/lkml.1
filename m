Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYIXVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYIXVTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYIXVTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:19:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:49773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYIXVTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:19:08 -0400
Message-ID: <48DAAEAB.50009@suse.com>
Date: Wed, 24 Sep 2008 17:18:35 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, arjan@linux.intel.com,
       reiserfs-devel@vger.kernel.org, peterz@infradead.org
Subject: Re: [LOCKDEP linux-2.6.27-rc7] reiserfs circular locking
References: <4807377b0809241139x18ea8ce4x7dbc66ba680be3e7@mail.gmail.com>	<48DA8D27.5080908@suse.com> <20080924221425.3b4939ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20080924221425.3b4939ba@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
>> I have a reiserfs patch set that should address this. I haven't
>> submitted it recently because I'm chasing down a reiserfs bug report
>> that may or may not be related to the patch set.
>>
>> You can grab the patch set out of an opensuse kernel src rpm.
> 
> Jeff: See also bugzilla.kernel.org #9136 which seems to match
> 
> BTW - does anyone have a view where the existing reiserfs bugs should be
> assigned as they are currently assigned to namesys...

They're fine being assigned to the reiserfs development list, it's just
that the address in bko is wrong. The current address is
reiserfs-devel@vger.kernel.org.

I'll take this bug over, though.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjarqsACgkQLPWxlyuTD7LCLQCdF5BDrD+cdYGlqFUZ+Pu5oi5/
aFsAnAhfHjv8oXjbR/zXTd1fuEa8abkj
=7ayP
-----END PGP SIGNATURE-----
