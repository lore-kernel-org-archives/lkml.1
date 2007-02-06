Return-Path: <linux-kernel-owner+w=401wt.eu-S1030586AbXBFXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbXBFXi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030590AbXBFXi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:38:58 -0500
Received: from main.gmane.org ([80.91.229.2]:51990 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030586AbXBFXi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:38:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [patch 0/3, resend] scripts, kbuild updates/fixes (against 2.6.20)
Date: Tue, 6 Feb 2007 23:38:47 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnesi4t8.90j.olecom@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Oleg Verych
> Newsgroups: gmane.linux.kernel
> Subject: [patch 0/3, resend] scripts, kbuild updates/fixes (against 2.6.20)
> Date: Tue, 06 Feb 2007 02:18:19 +0100

[]
> Due to almost zer0 activity, this may be last attempt.
>

Landed in -mm tree. Thank you, Andrew.

Happy testing, everyone. Your `acks' are required!

If something wrong with
-- external modules building on `ro' source tree (distros),
-- wrong CC options (arch maintainers),
-- wrong localversion(s) included (Debian ;),
-- something with initramfs or object list (makelst) generation,

i'm listening.

Thanks !

--
-o--=O`C  /. .\
 #oo'L O      o
<___=E M    ^--


