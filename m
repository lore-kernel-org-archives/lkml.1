Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbXKKAbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbXKKAbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbXKKAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:31:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37907 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbXKKAbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:31:03 -0500
Date: Sat, 10 Nov 2007 19:30:57 -0500
Message-Id: <200711110030.lAB0UvLx006968@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Warning: commit message does not conform to UTF-8. (mmotm "10-Nov-2007 22:46")
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm getting minor warnings when applying two patches from
<http://userweb.kernel.org/~akpm/mmotm/>

It's probably not serious but I wonder if checkpatch catches this.

Applying patch..git-net.patch
Warning: commit message does not conform to UTF-8.
You may want to amend it after fixing the message, or set the config
variable i18n.commitencoding to the encoding your project uses.

Applying patch..mnt_unbindable-fix.patch
Warning: commit message does not conform to UTF-8.
You may want to amend it after fixing the message, or set the config
variable i18n.commitencoding to the encoding your project uses.

Erez.
