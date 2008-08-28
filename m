Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYH1PgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYH1PgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYH1Pfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:35:54 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45617 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYH1Pfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:35:53 -0400
Message-ID: <48B6C5B1.1050109@kernel.org>
Date: Thu, 28 Aug 2008 08:35:13 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
References: <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de> <20080827185845.GA25669@us.ibm.com>
In-Reply-To: <20080827185845.GA25669@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry to get to this late.

I very much prefer this patch over the resuscitation of the cap_set_pg()
code.

[I would also like to advocate we combine it with making
CONFIG_SECURITY_FILE_CAPABILITIES=y the default config option.]

Cheers

Andrew

Serge E. Hallyn wrote:
| In any case, how about the following patch?
|
| If it is ok with everyone, then I'll rewrite the intro and send it
| out separately.
|
| thanks,
| -serge
|
|>From 0b69a9e882b07e33814aa15a2f5cdf90b92c7ec8 Mon Sep 17 00:00:00 2001
| From: Serge Hallyn <serue@us.ibm.com>
| Date: Wed, 27 Aug 2008 13:33:37 -0500
| Subject: [PATCH 1/1] file capabilities: add no_file_caps switch (v2)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFItsWw+bHCR3gb8jsRAg6RAKCJsG3GajbfGqEX6QnN2vdJlyAEXgCdGmdS
d/7ZcozkYSn4RvX/saISXBM=
=bnGm
-----END PGP SIGNATURE-----
