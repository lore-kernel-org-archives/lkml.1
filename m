Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYBOWKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYBOWKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYBOWKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:10:15 -0500
Received: from twin.jikos.cz ([213.151.79.26]:44826 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbYBOWKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:10:14 -0500
Date: Fri, 15 Feb 2008 23:09:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: =?ISO-8859-2?Q?Petr_Tit=ECra?= <P.Titera@century.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: e_powersaver.c
In-Reply-To: <47B5E61F.3030603@century.cz>
Message-ID: <Pine.LNX.4.64.0802152309140.7699@twin.jikos.cz>
References: <47B5E61F.3030603@century.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-2117598454-1203113399=:7699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-2117598454-1203113399=:7699
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 15 Feb 2008, Petr Tit=ECra wrote:

>    is there some reason for printing current voltage and multiplier of=20
> processor after each change? This change was added by commit 553ae38c.=20

Which tree is this commit in? Definitely not latest Linus' tree:

$ git pull
Already up-to-date.
$ git show 553ae38c
fatal: ambiguous argument '553ae38c': unknown revision or path not in the w=
orking tree.

--=20
Jiri Kosina
SUSE Labs

---1747641777-2117598454-1203113399=:7699--
