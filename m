Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbXE3LjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbXE3LjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXE3Liv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:38:51 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:63916 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXE3Liu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:38:50 -0400
To: agruen@suse.de
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com>
	<200705291907.29547.agruen@suse.de>
	<200705300547.AJG94871.SNTPGtMN@I-love.SAKURA.ne.jp>
	<200705300010.55742.agruen@suse.de>
In-Reply-To: <200705300010.55742.agruen@suse.de>
Message-Id: <200705302038.IBH25217.TNMSNGtP@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Wed, 30 May 2007 20:38:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andreas Gruenbacher wrote:
> I don't know what you are talking about -- the very first patch in the 
> AppArmor series adds the vfsmount parameter to security_inode_create().
I'm talking about "the current version" of AppArmor (I mean AppArmor available for
OpenSuSE 10.1/10.2, but I should call "the previous version" of AppArmor
if you call AppArmor in this series of patch "the current version") can't handle bind mounts.
I know "the next version" of AppArmor (I mean AppArmor in this series of patch)
will be able to handle bind mounts better if these vfsmount patches are adopted.

Thanks.
