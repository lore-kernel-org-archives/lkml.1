Return-Path: <linux-kernel-owner+w=401wt.eu-S933719AbYD1OjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbYD1OjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbYD1Ois
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:38:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:54254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbYD1Oiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:38:46 -0400
Message-Id: <20080428163731.774191296@T61.localnet>
User-Agent: quilt/0.46_cvs20080326-8
Date: Mon, 28 Apr 2008 18:37:31 +0200
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-fsdevel Mailinglist <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/3] Some more path_{get,put}() cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some patches where path_{get,put}() can be used instead of
dput()/mntput() pairs. The patches are against 2.6.25-mm1.

Cheers,
Jan


