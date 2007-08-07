Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbXHGGu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbXHGGu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXHGGuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:50:52 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:40530 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXHGGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:50:51 -0400
Message-ID: <46B81648.8080606@kernel.org>
Date: Mon, 06 Aug 2007 23:50:48 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
References: <20070806185231.GA21550@sergelap.austin.ibm.com>
In-Reply-To: <20070806185231.GA21550@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
>>From 1376764cbb54243f088cf00c39000c4f4418f461 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 6 Aug 2007 14:20:06 -0400
> Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)

Signed-off-by: Andrew Morgan <morgan@kernel.org>

Cheers

Andrew


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGuBZDQheEq9QabfIRAtoVAJ9uOG2q9Za0CJqmH0ueLgUHmRIABACdHW3c
SykZm/puZe5JPpiVPAF2rS8=
=Smnk
-----END PGP SIGNATURE-----
