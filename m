Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYLCUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYLCUf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYLCULx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:11:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYLCULw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:11:52 -0500
Message-ID: <4936E7D8.20900@redhat.com>
Date: Wed, 03 Dec 2008 12:11:04 -0800
From: Ben Woodard <woodard@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@google.com>,
       bluesmoke-devel <bluesmoke-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] driver for i5400 MCH
References: <20081201194623.3ce28246@pedra.chehab.org> <20081202223347.bf6506f1.akpm@linux-foundation.org>
In-Reply-To: <20081202223347.bf6506f1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> Both you and Ben Woodard are listed under MODULE_AUTHOR.  Should
> this patch have Ben's Signed-off-by:?  And/or his From:?
Go ahead and add a:
Signed-off-by: Ben Woodard <woodard@redhat.com>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Red Hat - http://enigmail.mozdev.org

iD8DBQFJNufYYuGAPpw3tAARAlA5AJ4hNh6Mzzs60atqL06MkoD7RulsbwCdGSP7
DIQiX8F4+1eQXYeZPSQkc0M=
=anBc
-----END PGP SIGNATURE-----

