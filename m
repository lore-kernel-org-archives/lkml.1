Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbXJSOPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbXJSOPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbXJSOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:15:28 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:60882 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbXJSOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:15:28 -0400
To: bunk@kernel.org
CC: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <20071019140518.GE3778@stusta.de> (message from Adrian Bunk on
	Fri, 19 Oct 2007 16:05:18 +0200)
Subject: Re: [2.6 patch] fuse_file_alloc(): fix NULL dereferences
References: <20071019140518.GE3778@stusta.de>
Message-Id: <E1Iisco-0008HH-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Oct 2007 16:14:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch fixes obvious NULL dereferences spotted by the Coverity 
> checker.

Thanks!

Miklos
