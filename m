Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYCZPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYCZPcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYCZPcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:32:01 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:44960 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYCZPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:32:00 -0400
Message-ID: <47EA6C3F.40408@kernel.org>
Date: Wed, 26 Mar 2008 08:31:11 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Linux Containers <containers@lists.osdl.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil> <20080325134001.GB5984@sergelap.austin.rr.com> <1206455835.3302.185.camel@moss-spartans.epoch.ncsc.mil> <20080325180611.GB19176@sergelap.ibm.com> <20080325215555.GB12770@elf.ucw.cz>
In-Reply-To: <20080325215555.GB12770@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

FWIW. I completely concur.

Pavel Machek wrote:
|> Herbert, Pavel, do you have objections to allowing ptrace of init?
|> (I believe Eric has already Acked the idea iirc?)
|
| No problem from me...
|
| (..but do not introduce command line option or sysctl. It is not worth
it).

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH6mw8+bHCR3gb8jsRAsKjAJ40JnoyrqGzgIZPgz5gv9uqeeiZ1wCdFKSv
snEU/yiVdWQ4cGSwbU3A8Hg=
=xArK
-----END PGP SIGNATURE-----
